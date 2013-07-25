#!/usr/bin/env jruby

# Example mostly taken from (and converted to jrubyfx/Ruby):
# http://jperedadnr.blogspot.com/2013/06/leap-motion-controller-and-javafx-new.html
# At the time this was committed it uses at least one unreleased feature in
# JRubyFX so you should run from master with:
# CLASSPATH=../leap_sdk/LeapSDK/lib/LeapJava.jar jruby -J-Djava.library.path=../leap_sdk/LeapSDK/lib -Ilib:../jrubyfx/lib  examples/finger_sphere.rb 
require 'jrubyfx'
require 'reapmotion'

java_import com.leapmotion.leap.Controller
java_import com.leapmotion.leap.Listener


class SphereFinger < JRubyFX::Application
  WIDTH, HEIGHT = 800, 600
  RADIUS = 50.0
  DIAMETER = 2 * RADIUS
  
  def start(stage)
    listener = SimpleLeapListener.new
    listener.point_property.add_change_listener do |ov, t, t1|
      run_later do
        scene = stage.scene
        window = scene.window
        pane = stage['#canvas']
        d = pane.scene_to_local(t1.x-scene.x-window.x, t1.y-scene.y-window.y)
        if d.x >= RADIUS && d.x <= pane.width-RADIUS &&
            d.y >= RADIUS && d.y <= pane.height-RADIUS
          circle = stage['#finger']
          circle.translate_x = d.x
          circle.translate_y = d.y
        end
      end
    end
    Thread.new { com.leapmotion.leap.Controller.run(listener) { gets } }
    with(stage, init_style: :transparent, width: WIDTH, height: HEIGHT,
         title: 'Sphere Finger', resizable: false) do
      layout_scene do
        anchor_pane(id: 'canvas', width: WIDTH, height: HEIGHT) do
          circle(id: 'finger', radius: RADIUS, fill: :green)
        end
      end
      show
    end
  end
end

class SimpleLeapListener < Listener
  java_import(java.lang.Math) { |p, n| "J" + n }
  java_import javafx.geometry.Point2D
  include JRubyFX::DSL
  property_accessor :point, :key_tap

  def initialize()
    super()
    @position_average = LimitQueue.new(10)
    @point = simple_object_property
    @key_tap = simple_object_property
  end

  def onFrame(controller)
    frame = controller.frame
    if !frame.hands.empty?
      screen = controller.calibrated_screens.get(0)
      if screen && screen.valid?
        hand = frame.hands[0]
        if hand.valid?
          intersect = screen.intersect(hand.palm_position, hand.direction, true)
          @position_average << intersect
          a_x, a_y = average(@position_average)
          new_point = Point2D.new(screen.width_pixels * JMath.min(1, JMath.max(0,a_x)),
                                  screen.height_pixels * JMath.min(1,JMath.max(0,(1-a_y))))
          @point.set_value(new_point)
        end
      end
    end
    @key_tap.set false
    frame.gestures do |gesture|
      @key_tap.set(true) if gesture.type == Gesture.Type.TYPE_KEY_TAP
    end
  end
     
  def average(vectors)
    vx, vy = 0, 0

    vectors.each { |v| vx, vy = vx + v.x, vy + v.y }

    return vx/vectors.size, vy/vectors.size
  end
     
  class LimitQueue < Array
    def initialize(limit)
      super()
      @limit = limit
    end

    def <<(o)
      super(o)
      self[0..(size - @limit)] = [] if size > @limit
    end
  end
end

SphereFinger.launch

require 'reapmotion'

java_import com.leapmotion.leap.Controller
java_import com.leapmotion.leap.Listener
java_import com.leapmotion.leap.CircleGesture
java_import com.leapmotion.leap.Gesture
java_import com.leapmotion.leap.Vector

JMath = java.lang.Math

class SampleListener < Listener
  def onInit(controller)
    puts "Initialized"
  end

  def onConnect(controller)
    puts "Connected"

    controller.enable_gestures(:swipe, :circle, :screen_tap, :key_tap)
  end

  def onDisconnect(controller) # Not called if run through debugger
    puts "Disconnected"
  end

  def onExit(controller)
    puts "Exited"
  end

  def onFrame(controller)
    # Get the most recent frame and report some basic information
    frame = controller.frame
    
    puts "Frame id: #{frame.id}, timestamp: #{frame.timestamp}, hands: #{frame.hands.count}, fingers: #{frame.fingers.count}, tools: #{frame.tools.count}, gestures #{frame.gestures.count}"

    if !frame.hands.empty?
      # Get the first hand
      hand = frame.hands[0]

      # Check if the hand has any fingers
      fingers = hand.fingers
      if !fingers.empty?
        # Calculate the hand's average finger tip position
        avgPos = fingers.inject(Vector.zero) do |s, finger| 
          s.plus(finger.tip_position)
        end.divide(fingers.count)
        puts "Hand has #{fingers.count} fingers, average finger tip position: #{avgPos}"
      end

      # Get the hand's sphere radius and palm position
      puts "Hand sphere radius: #{hand.sphereRadius} mm, palm position: #{hand.palmPosition}"

      # Get the hand's normal vector and direction
      normal = hand.palmNormal
      direction = hand.direction

      # Calculate the hand's pitch, roll, and yaw angles
      puts "Hand pitch: #{JMath.toDegrees(direction.pitch)} degrees, roll: #{JMath.toDegrees(normal.roll)} degrees, yaw: #{JMath.toDegrees(direction.yaw)} degrees"

      frame.gestures do |gesture|
        case gesture.type
        when Gesture::Type::TYPE_CIRCLE then
          clockwiseness = gesture.clockwise? ? "clockwise" : "counterclockwise"

          # Calculate angle swept since last frame
          sweptAngle = 0.0
          if gesture.state != Gesture::State::STATE_START
            previousUpdate = CircleGesture.new controller.frame(1).gesture(gesture.id)
            sweptAngle = (gesture.progress - previousUpdate.progress) * 2 * Math::PI
          end

          puts "Gesture id: #{gesture.id}, #{gesture.state}, progress: #{gesture.progress}, radius: #{gesture.radius}, angle: #{JMath.toDegrees(sweptAngle)}, #{clockwiseness}"
        when Gesture::Type::TYPE_SWIPE then
          puts "Gesture id: #{gesture.id}, #{gesture.state}, position: #{gesture.position}, direction: #{gesture.direction}, speed: #{gesture.speed}"
        when Gesture::Type::TYPE_SCREEN_TAP then
          puts "Screen Tap id: #{gesture.id}, #{gesture.state}, position: #{gesture.position}, direction: #{gesture.direction}"
        when Gesture::Type::TYPE_KEY_TAP then
          puts "Key Tap id: #{gesture.id}, #{gesture.state}, position: #{gesture.position}, direction: #{gesture.direction}"
        else
          puts "Unknown gesture type."
        end
      end
    end
  end
end

# Create a sample listener and controller
Controller.run(SampleListener.new) do
  puts "Press Enter to quit..."
  gets
end


require 'reapmotion'

java_import com.leapmotion.leap.CircleGesture
java_import com.leapmotion.leap.Controller
java_import com.leapmotion.leap.Listener
java_import com.leapmotion.leap.Gesture
java_import com.leapmotion.leap.KeyTapGesture
java_import com.leapmotion.leap.ScreenTapGesture
java_import com.leapmotion.leap.SwipeGesture
java_import com.leapmotion.leap.Vector

JMath = java.lang.Math

class SampleListener < Listener
  def onInit(controller)
    puts "Initialized"
  end

  def onConnect(controller)
    puts "Connected"
    
    controller.enable_gesture(Gesture::Type::TYPE_SWIPE)
    controller.enable_gesture(Gesture::Type::TYPE_CIRCLE)
    controller.enable_gesture(Gesture::Type::TYPE_SCREEN_TAP)
    controller.enable_gesture(Gesture::Type::TYPE_KEY_TAP)
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

      frame.gestures.each do |gesture|
        case gesture.type
        when Gesture::Type::TYPE_CIRCLE then
          circle = CircleGesture.new gesture
          
          # Calculate clock direction using the angle between circle normal and pointable
          if circle.pointable.direction.angleTo(circle.normal) <= JMath::PI/4
            # Clockwise if angle is less than 90 degrees
            clockwiseness = "clockwise"
          else
            clockwiseness = "counterclockwise"
          end

          # Calculate angle swept since last frame
          sweptAngle = 0.0
          if circle.state != Gesture::State::STATE_START
            previousUpdate = CircleGesture.new controller.frame(1).gesture(circle.id)
            sweptAngle = (circle.progress - previousUpdate.progress) * 2 * JMath::PI
          end

          puts "Circle id: #{circle.id}, #{circle.state}, progress: #{circle.progress}, radius: #{circle.radius}, angle: #{JMath.toDegrees(sweptAngle)}, #{clockwiseness}"
        when Gesture::Type::TYPE_SWIPE then
          swipe = SwipeGesture.new gesture
          puts "Swipe id: #{swipe.id}, #{swipe.state}, position: #{swipe.position}, direction: #{swipe.direction}, speed: #{swipe.speed}"
        when Gesture::Type::TYPE_SCREEN_TAP then
          screenTap = ScreenTapGesture.new gesture
          puts "Screen Tap id: #{screenTap.id}, #{screenTap.state}, position: #{screenTap.position}, direction: #{screenTap.direction}"
        when Gesture::Type::TYPE_KEY_TAP then
          keyTap = KeyTapGesture.new gesture
          puts "Key Tap id: #{keyTap.id}, #{keyTap.state}, position: #{keyTap.position}, direction: #{keyTap.direction}"
        else
          puts "Unknown gesture type."
        end
      end
    end
  end
end

# Create a sample listener and controller
listener = SampleListener.new
controller = Controller.new

# Have the sample listener receive events from the controller
controller.addListener listener

# Keep this process running until Enter is pressed
puts "Press Enter to quit..."
gets
# Remove the sample listener when done
controller.removeListener listener


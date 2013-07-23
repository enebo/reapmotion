class com::leapmotion::leap::Frame
  java_import com.leapmotion.leap.Gesture
  java_import com.leapmotion.leap.CircleGesture
  java_import com.leapmotion.leap.SwipeGesture
  java_import com.leapmotion.leap.ScreenTapGesture
  java_import com.leapmotion.leap.KeyTapGesture
  
  GESTURE_TYPE_MAP = {
    Gesture::Type::TYPE_CIRCLE => CircleGesture,
    Gesture::Type::TYPE_SWIPE => SwipeGesture,
    Gesture::Type::TYPE_SCREEN_TAP => ScreenTapGesture,
    Gesture::Type::TYPE_KEY_TAP => KeyTapGesture,
  }

  alias gestures_original gestures

  def gestures
    # Original Java path
    return gestures_original unless block_given?

    gestures_original.each do |gesture|
      type = GESTURE_TYPE_MAP[gesture.type] 

      raise ArgumentError.new("unknown type #{gesture.type}") unless type

      yield type.new(gesture)
    end
  end

end

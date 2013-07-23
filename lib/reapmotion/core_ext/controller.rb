class com::leapmotion::leap::Controller
  java_import com.leapmotion.leap.Gesture

  GESTURE_MAP = {
    "swipe" => Gesture::Type::TYPE_SWIPE,
    "circle" => Gesture::Type::TYPE_CIRCLE,
    "screen_tap" => Gesture::Type::TYPE_SCREEN_TAP,
    "key_tap" => Gesture::Type::TYPE_KEY_TAP
  }

  def enable_gestures(*list)
    list.each do |sym|
      type = GESTURE_MAP[sym.to_s]
      
      raise TypeError.new("#{sym} is not a valid gesture type") unless type

      enable_gesture(type)
    end
  end
end

class com::leapmotion::leap::CircleGesture
  def clockwise?
    pointable.direction.angleTo(normal) <= Math::PI/4
  end

  def counter_clockwise?
    !clock_wise?
  end
end

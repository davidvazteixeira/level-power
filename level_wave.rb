# frozen_string_literal: true

# Base function to create a line + sin progression
class Wave
  def initialize(angular, amp, freq)
    @a = angular
    @amp = amp
    @w = freq
    @t0 = -x_min_origin
  end

  def at(step)
    @a * (step - @t0) + @amp * Math.cos(@w * (step - @t0))
  end

  def x_min_origin
    (-Math.asin(@a / (@amp * @w)) + Math::PI)
    (-Math.asin(@a / (@amp * @w)) + Math::PI) / @w
  end

  def x_min(level)
    (-Math.asin(@a / (@amp * @w)) + 2 * Math::PI * level + @t0 * @w + Math::PI) / @w
  end

  def x_max(level)
    (Math.asin(@a / (@amp * @w)) + 2 * Math::PI * level + @t0 * @w) / @w
  end
end

# Power class using wave class
class Power
  def initialize(angular, amp, freq)
    @wave = Wave.new(angular, amp, freq)
    @c = @wave.at(0)
  end

  def at(step)
    @wave.at(step) - @c + 1
  end

  def x_min(level)
    @wave.x_min(level - 1)
  end

  def x_max(level)
    @wave.x_max(level - 1)
  end

  def y_min(level)
    at(x_min(level - 1))
  end

  def y_max(level)
    at(x_max(level - 1))
  end
end

# Tool to create a level progression
class LevelPower
  def initialize(level, level_steps, power_options = [])
    @power = Power.new(*power_options)
    @level = level
    @level_steps = level_steps
    create_level_powers
  end

  attr_reader :powers

  def power(step)
    @powers[step]
  end

  def create_level_powers
    s = @power.x_min(@level)
    e = @power.x_min(@level + 1)
    by = (e - s) / @level_steps
    @powers = (s..e).step(by).to_a.map { |y| @power.at(y) }
  end
end


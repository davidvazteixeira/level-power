# frozen_string_literal: true

require_relative 'level_wave'

# Using
level = 2
level_steps = 30

level_power = LevelPower.new(level, level_steps, [0.5, 5, 0.5])

puts "Level #{level} - Step: Power"
30.times do |step|
  power = level_power.power(step)
  puts "#{step}:\t#{power.round(1)}"

  # bang bang bang bang!
end

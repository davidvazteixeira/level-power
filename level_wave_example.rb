# frozen_string_literal: true

require_relative 'level_wave'

# Using
level = 2
steps = 30
power = { angular: 0.5, amp: 5, freq: 0.5 }
level_power = LevelPower.new(level: level, steps: steps, power: power)

puts "Level #{level} - Step: Power"
30.times do |step|
  power = level_power.power(step)
  puts "#{step}:\t#{power.round(1)}"

  # bang bang bang bang!
end

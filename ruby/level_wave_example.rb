# frozen_string_literal: true

require_relative 'level_wave'

# Using
level = 2
steps = 30
power = { angular: 0.5, amp: 5, freq: 0.5 }
level_power = LevelPower.new(level: level, steps: steps, power: power)

puts level_power.powers

puts "Level #{level}"
puts "Step: \tPower"
level_power.powers.each_with_index do |power, step|
  puts "#{step}:\t#{power.round(1)}"
  # bang bang bang bang!
end


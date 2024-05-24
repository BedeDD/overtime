require 'time'

# expected file content format:
# 02.10.2023, 06:24
# 02.10.2023, 15:26
# 04.10.2023, 06:26
# 04.10.2023, 14:44

entries = {}
File.foreach('timesheet.txt') do |line|
  timestamp = Time.parse(line.chomp)
  entries[timestamp.to_date.to_s] = Array(entries[timestamp.to_date.to_s]).compact + Array(timestamp.to_i)
end

def calc_hours(times)
  times.each_slice(2).map { |start, stop| (stop - start) }
rescue StandardError => _e
  0
end

entries.each do |date, times|
  entries[date] = { times: times, hours: calc_hours(times) }
  entries[date][:work_hours_with_breaks] = Array(entries[date][:hours]).sum / 3600.0
  whwb = entries[date][:work_hours_with_breaks]

  # breaks per german law
  net_hours = case whwb.round
              when 0..4 then whwb
              when 4..8 then whwb - 0.5
              else
                whwb - 0.75
              end
  entries[date][:work_hours] = net_hours
  entries[date][:overtime] = net_hours - 8
end

total_overtime = entries.values.sum { |entry| entry[:overtime] }
hours, minutes = total_overtime.divmod(1)
puts "OVERTIME ACCUMULATED UNTIL NOW: #{hours}h #{(minutes * 60).round}m"

invalid_entries = entries.select { |_, entry| entry[:work_hours] == 0 }.keys
if invalid_entries.length > 0
  puts '========'
  puts "Invalid entries: #{entries.select { |_, entry| entry[:work_hours] == 0 }.keys}"
end


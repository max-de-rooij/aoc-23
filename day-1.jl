# get the first digit of the calibration document
function get_first_calibration_digits(inputlines)
  map(x -> first(filter(isdigit, x)), inputlines)
end

# get the last digit of the calibration document
function get_last_calibration_digits(inputlines)
  map(x -> last(filter(isdigit, x)), inputlines)
end

# compute the calibration using a possibly different right input (used for part 2)
function calibrate(left_input, right_input=left_input)
  sum(x->parse(Int, x), get_first_calibration_digits(left_input) .* get_last_calibration_digits(right_input))
end

# part 1: calibrate using only digits
calibration_value_1 = open("input_files/day-1-input.txt", "r") do io 
  calibrate(split(read(io, String),"\n")) 
end

# create a word to digit mapping
mapping = [
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"]

# create a reverse mapping for overlapping words at the end
reverse_mapping = [reverse(key) => val for (key,val) in mapping]

# calibrate using digits and words, using the reverse mapping for the right_input
calibration_value_2 = open("input_files/day-1-input.txt", "r") do io
  lines = split(read(io, String),"\n")
  calibrate(map(x -> replace(x, mapping...), lines), reverse.(map(x -> replace(reverse(x), reverse_mapping...), lines)))
end

println("The answer to 1-1 is $(calibration_value_1)")
println("The answer to 1-2 is $(calibration_value_2)")
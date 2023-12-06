function break_record(duration::Number, record::Number)
  if duration^2 - 4*record < 0
    return 0
  else
    max_hold = Int(floor(-0.5*(-duration - (duration^2 - 4*record)^0.5)))
    min_hold = Int(ceil(-0.5*(-duration + (duration^2 - 4*record)^0.5)))

    min_hold = min_hold < 0 ? 0 : min_hold
    max_hold = max_hold > duration ? Int(duration) : max_hold
    return 1 + max_hold - min_hold
  end
end

break_record(dr::Tuple{Number, Number}) = break_record(dr[1], dr[2])


# read and parse the input file for part 1
inputfile = "input_files/day-6-input.txt"
times, distances = open(inputfile, "r") do io 
  lines = readlines(io) 
  (parse.(Int, split(lines[startswith.(lines, "Time:")][1])[2:end]), parse.(Int, split(lines[startswith.(lines, "Distance:")][1])[2:end]))
end

part_1_answer = prod(break_record, zip(times, distances))

# read and parse the input file for part two
p2_time = parse(Int, join(["$i" for i in times]))
p2_distance = parse(Int, join(["$i" for i in distances]))
part_2_answer = break_record(p2_time, p2_distance)


println("The answer to 6-1 is $(part_1_answer)")
println("The answer to 6-2 is $(part_2_answer)")

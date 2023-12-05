

function map_value(value, mv)
  for r in eachrow(mv)
    if r[2] <= value <= (r[2]+r[3]-1)
      return r[1]+value-r[2]
    end
  end
  return value
end

function create_maps(lines)
  map_starts = (2:length(lines))[iszero.([isdigit(l[1]) for l in lines[2:end]])]
  map_lengths = [diff(map_starts); length(lines)-map_starts[end]+1]
  maps = [
    lines[map_start+1:map_start+map_length-1] for (map_start, map_length) in zip(map_starts, map_lengths)
  ]
  [parse.(Int, hcat(split.(mapping, ' ')...))' for mapping in maps]
end

function map_seed!(seed, maps)
  for _map in maps
    seed = map_value(seed, _map)
  end
  seed
end

function minimum_map_seeds(seeds, maps)
  minimum(x -> map_seed!(x, maps), seeds)
end

function minimum_map_ranged_seeds(seeds_ranged, maps)
  minimum(x -> minimum_map_seeds(x, maps), seeds_ranged)
end

lines = open("input_files/day-5-input.txt", "r") do io
  filter(x -> x != "", readlines(io))
end

# part 1 
seeds = parse.(Int,split(strip(split(lines[1], ':')[2])))
maps = create_maps(lines)

answer_part_1 = minimum_map_seeds(seeds, maps)

# part 2
seed_numbers = copy(seeds)
seeds_ranged = [seed_numbers[i]:seed_numbers[i] + seed_numbers[i+1] for i in 1:2:length(seed_numbers)]
answer_part_2 = minimum_map_ranged_seeds(seeds_ranged, maps)

println("The answer to 5-1 is $(answer_part_1)")
println("The answer to 5-2 is $(answer_part_2)")
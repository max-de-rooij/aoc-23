filepath = "input_files/day-4-input.txt"
filecontent = open(filepath, "r") do io
  split.(last.(split.(readlines(io), ':')), '|')
end

function compute_score(filecontent)
  score = 0
  for line in filecontent
    winners = parse.(Int, filter(x -> x != "", split(strip(line[1]), ' ')))
    numbers = parse.(Int, filter(x -> x != "", split(strip(line[2]), ' ')))
    matches = sum(win ∈ numbers for win in winners)
    score += matches > 0 ? 2^(matches-1) : 0
  end
  score
end

part_1_answer = compute_score(filecontent)

function compute_owned_cards(filecontent)
  cards_owned = repeat([1], length(filecontent))
  for (i, line) in enumerate(filecontent)
    winners = parse.(Int, filter(x -> x != "", split(strip(line[1]), ' ')))
    numbers = parse.(Int, filter(x -> x != "", split(strip(line[2]), ' ')))
    matches = sum(win ∈ numbers for win in winners)
    if matches > 0
      cards_owned[i+1:i+matches] .+= cards_owned[i]
    end
  end
  return sum(cards_owned)
end

part_2_answer = compute_owned_cards(filecontent)

println("The answer to 4-1 is $(part_1_answer)")
println("The answer to 4-2 is $(part_2_answer)")


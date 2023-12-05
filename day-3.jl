function isvalidindex(index, arr)
  if 0 ∈ Tuple(index) || any(Tuple(index) .> size(arr))
    return false
  else
    return true
  end
end

function create_box(i, j, width)
  box = [CartesianIndex(i, j-1), CartesianIndex(i, j+width)]
  box = [box; [CartesianIndex(i - 1, k) for k in j-1:j+width]]
  [box; [CartesianIndex(i + 1, k) for k in j-1:j+width]]
end

function get_machine_parts(filecontent)
  numbers = (0x30 .<= filecontent .<= 0x39)
  symbols = filecontent .!= 0x2e .&& .!(numbers)

  part_numbers = []
  for j in axes(numbers,2), i in axes(numbers, 1)
    num = numbers[i,j]
    if num > 0 && (j == 1 || numbers[i,j-1] == 0)
      width = 0

      # identify number size
      while num > 0 && size(numbers)[2] >= j+width+1
        num *= numbers[i,j+width+1]
        width += 1
      end

      if numbers[i, j+width] != 0
        width+=1
      end
      
      # create box
      box = create_box(i,j,width)
      box = filter(x -> isvalidindex(x, numbers), box)
      value = parse(Int,String(filecontent[i,j:(j+width-1)]))
      if sum(symbols[box]) > 0
        push!(part_numbers, value)
      end

    end
  end
  part_numbers
end

function get_gears(filecontent)
  numbers = (0x30 .<= filecontent .<= 0x39)
  stars = filecontent .== 0x2a

  gears = zeros(size(stars))
  ratios = ones(size(stars))

  for j in axes(numbers,2), i in axes(numbers, 1)
    num = numbers[i,j]
    if num > 0 && (j == 1 || numbers[i,j-1] == 0)
      width = 0

      # identify number size
      while num > 0 && size(numbers)[2] >= j+width+1
        num *= numbers[i,j+width+1]
        width += 1
      end

      if numbers[i, j+width] != 0
        width+=1
      end
      
      # create box
      box = create_box(i,j,width)
      box = filter(x -> isvalidindex(x, numbers), box)
      value = parse(Int,String(filecontent[i,j:(j+width-1)]))
      gears[box] += stars[box]
      ratios[box] .*= stars[box].*value
    end
  end
  gears, ratios
end


filepath = "input_files/day-3-input.txt"
filecontent = open(filepath, "r") do io
  UInt8.(hcat(collect.(readlines(io))...))'
end

part_numbers = get_machine_parts(filecontent)
println("The answer to 3-1 is $(sum(part_numbers))")

gears, ratios = get_gears(filecontent)
println("The answer to 3-2 is $(Int(sum(ratios[gears .== 2.])))")
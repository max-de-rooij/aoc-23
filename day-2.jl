import Base.>
inputfile = "input_files/day-2-input.txt"

# define colors
const R = "red"; B = "blue"; G = "green"

# get the color and the value from the string
function getpair(color)
  ([R,G,B][occursin.([R, G, B], color)][1], parse(Int, filter(isdigit, color)))
end

# cubeset object
struct CubeSet{T<:Int}
  red::T
  green::T
  blue::T
end

# create a cubeset from a string
function CubeSet(s)
  colors = split(s, ',')
  result = Dict(R => 0, G => 0, B => 0)
  for color in colors
    c, v = getpair(color)
    result[c] = v
  end

  CubeSet(
    result["red"],
    result["green"],
    result["blue"]
  )
end

# compare cubesets
function (>)(a::CubeSet, b::CubeSet)
  a.red > b.red || a.green > b.green || a.blue > b.blue
end

# power of a cubeset
function power(cs::CubeSet)
  cs.red*cs.blue*cs.green
end

# game object
struct Game{T<:Int}
  id::T
  sets::Vector{CubeSet{T}}
end

function Game(s)
  gameid, sets = split(s, ':')
  cubesets = CubeSet.(split(sets, ';'))
  Game(
    parse(Int, filter(isdigit, gameid)),
    cubesets
  )
end

function checkgame(game::Game{T}, referenceset::CubeSet{T}) where T<:Int
  !any([st > referenceset for st in game.sets])
end

function minimum_cubeset(game::Game{T}) where T<:Int
  CubeSet(
    maximum([s.red for s in game.sets]),
    maximum([s.green for s in game.sets]),
    maximum([s.blue for s in game.sets])
  )
end

games = open(inputfile, "r") do io
  Game.(split(read(io, String), '\n'))
end

reference = CubeSet(
  12, 13, 14
)

part_1_answer = sum(x -> checkgame(x, reference)*x.id, games)
part_2_answer = sum(x -> power(minimum_cubeset(x)), games)

println("The answer to 2-1 is $(part_1_answer)")
println("The answer to 2-2 is $(part_2_answer)")
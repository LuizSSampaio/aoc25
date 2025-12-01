import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

/// Must receive an file containing dial move instructions and return the number of times that the dial reached 0
pub fn solve() -> Int {
  let assert Ok(content) = simplifile.read(from: "res/day1.txt")
  content
  |> string.split("\n")
  |> list.map(parse_intruction)
  |> solve_instructions(50)
}

fn solve_instructions(instructions: List(Int), start: Int) -> Int {
  let acc =
    { start + { list.first(instructions) |> result.unwrap(0) } } |> wrap()
  let counter = case acc {
    0 -> 1
    _ -> 0
  }

  case list.length(instructions) > 1 {
    True ->
      { instructions |> list.drop(1) |> solve_instructions(acc) } + counter
    False -> counter
  }
}

fn parse_intruction(instruction: String) -> Int {
  case instruction {
    "R" <> val -> int.parse(val) |> result.unwrap(0)
    "L" <> val -> -1 * { int.parse(val) |> result.unwrap(0) }
    _ -> 0
  }
}

fn wrap(n: Int) -> Int {
  let reminder = n % 100
  case reminder < 0 {
    True -> reminder + 100
    False -> reminder
  }
}

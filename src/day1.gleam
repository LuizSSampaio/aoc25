import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

/// Must receive an file containing dial move instructions and return the number of times that the dial reached 0
pub fn solve(input_path: String) -> #(Int, Int) {
  let assert Ok(content) = simplifile.read(from: input_path)
  content
  |> string.split("\n")
  |> list.map(parse_instruction)
  |> solve_instructions(50)
}

fn solve_instructions(instructions: List(Int), start: Int) -> #(Int, Int) {
  list.fold(instructions, #(0, 0, start), fn(acc, instruction) {
    let #(counter1, counter2, pos) = acc
    let new_pos = wrap(pos + instruction)
    let passes = pass_zero(pos, instruction)
    let hits = case new_pos {
      0 -> 1
      _ -> 0
    }

    #(counter1 + hits, counter2 + passes, new_pos)
  })
  |> fn(res) { #(res.0, res.1) }
}

fn parse_instruction(instruction: String) -> Int {
  case instruction {
    "R" <> val -> int.parse(val) |> result.unwrap(0)
    "L" <> val -> -1 * { int.parse(val) |> result.unwrap(0) }
    _ -> 0
  }
}

fn wrap(n: Int) -> Int {
  let remainder = n % 100
  case remainder < 0 {
    True -> remainder + 100
    False -> remainder
  }
}

fn pass_zero(start: Int, rotation: Int) -> Int {
  let rotation_magnitude = { rotation / 100 } |> int.absolute_value()
  let rotation_reduced = rotation % 100

  case start + rotation_reduced {
    x if x <= 0 && start != 0 -> 1
    x if x >= 100 -> 1
    _ -> 0
  }
  + rotation_magnitude
}

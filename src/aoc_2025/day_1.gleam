import gleam/int
import gleam/list
import utils/parse_utils
import utils/result_utils

const start_pos = 50

pub fn parse(input: String) -> List(Int) {
  input
  |> parse_utils.parsed_lines(fn(line) {
    case line {
      "R" <> val -> parse_utils.unsafe_int_parse(val)
      "L" <> val -> parse_utils.unsafe_int_parse(val) |> int.negate()
      _ -> 0
    }
  })
}

pub fn pt_1(rotations: List(Int)) -> Int {
  list.fold(rotations, #(0, start_pos), fn(acc, rotation) {
    let #(counter, pos) = acc
    let new_pos = wrap(pos + rotation)
    let hits = case new_pos {
      0 -> 1
      _ -> 0
    }

    #(counter + hits, new_pos)
  }).0
}

pub fn pt_2(rotations: List(Int)) -> Int {
  list.fold(rotations, #(0, start_pos), fn(acc, rotation) {
    let #(counter, pos) = acc
    let new_pos = wrap(pos + rotation)
    let passes = pass_zero(pos, rotation)

    #(counter + passes, new_pos)
  }).0
}

fn wrap(n: Int) -> Int {
  let remainder = n |> int.remainder(100) |> result_utils.unsafe_unwrap()
  case remainder < 0 {
    True -> remainder + 100
    False -> remainder
  }
}

fn pass_zero(start: Int, rotation: Int) -> Int {
  let rotation_magnitude =
    rotation
    |> int.divide(100)
    |> result_utils.unsafe_unwrap()
    |> int.absolute_value()
  let rotation_reduced =
    rotation |> int.remainder(100) |> result_utils.unsafe_unwrap()

  case start + rotation_reduced {
    x if x <= 0 && start != 0 -> 1
    x if x >= 100 -> 1
    _ -> 0
  }
  + rotation_magnitude
}

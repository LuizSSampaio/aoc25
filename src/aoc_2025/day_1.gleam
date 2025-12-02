import gleam/int
import gleam/list
import gleam/result
import gleam/string

const start_pos = 50

pub fn parse(input: String) -> List(Int) {
  input
  |> string.split("\n")
  |> list.map(fn(instruction) {
    case instruction {
      "R" <> val -> int.parse(val) |> result.unwrap(0)
      "L" <> val -> int.parse(val) |> result.unwrap(0) |> int.negate()
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
  let remainder = n |> int.remainder(100) |> result.unwrap(0)
  case remainder < 0 {
    True -> remainder + 100
    False -> remainder
  }
}

fn pass_zero(start: Int, rotation: Int) -> Int {
  let rotation_magnitude =
    rotation |> int.divide(100) |> result.unwrap(0) |> int.absolute_value()
  let rotation_reduced = rotation |> int.remainder(100) |> result.unwrap(0)

  case start + rotation_reduced {
    x if x <= 0 && start != 0 -> 1
    x if x >= 100 -> 1
    _ -> 0
  }
  + rotation_magnitude
}

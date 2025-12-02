import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import utils/parse_utils

pub fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.split(",")
  |> list.map(fn(range) {
    let assert [from, to] =
      range
      |> string.trim()
      |> string.split("-")
      |> list.map(parse_utils.unsafe_parse)
    #(from, to)
  })
}

pub fn pt_1(ranges: List(#(Int, Int))) -> Int {
  solve(ranges, id_is_valid_pt1)
}

pub fn pt_2(ranges: List(#(Int, Int))) -> Int {
  solve(ranges, id_is_valid_pt2)
}

fn solve(ranges: List(#(Int, Int)), id_validator: fn(String) -> Bool) -> Int {
  ranges
  |> list.fold(0, fn(acc, range) {
    let invalid_sum =
      list.range(range.0, range.1)
      |> list.fold(0, fn(sum, id) {
        case id |> int.to_string() |> id_validator() {
          True -> sum
          False -> sum + id
        }
      })
    acc + invalid_sum
  })
}

fn id_is_valid_pt1(id: String) -> Bool {
  let len = string.length(id)
  use <- bool.guard(len % 2 != 0, True)
  let half = string.slice(id, 0, len / 2)
  half <> half != id
}

fn id_is_valid_pt2(id: String) -> Bool {
  let len = string.length(id)
  let max_prefix_len = len / 2
  list.range(1, max_prefix_len)
  |> list.all(fn(repeating_len) {
    use <- bool.guard(len % repeating_len != 0 || len == 1, True)
    let repeat_to_check = string.slice(id, 0, repeating_len)
    let repeat_times = len / repeating_len
    let check_against = string.repeat(repeat_to_check, repeat_times)
    check_against != id
  })
}

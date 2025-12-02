import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Range(kind) {
  Range(min: kind, max: kind)
}

pub fn pt_1(input: String) -> Int {
  solve(input, id_is_valid_pt1)
}

pub fn pt_2(input: String) -> Int {
  solve(input, id_is_valid_pt2)
}

fn solve(input: String, id_validator: fn(String) -> Bool) -> Int {
  input
  |> string.split(",")
  |> list.map(parse_range)
  |> list.fold(0, fn(acc, range) {
    let invalid_sum =
      list.range(range.min, range.max)
      |> list.fold(0, fn(sum, id) {
        case id |> int.to_string() |> id_validator() {
          True -> sum
          False -> sum + id
        }
      })
    acc + invalid_sum
  })
}

fn parse_range(range: String) -> Range(Int) {
  let parts = range |> string.trim() |> string.split("-")
  list.each(parts, string.trim)
  let part0 =
    parts
    |> list.first()
    |> result.unwrap("0")
    |> int.parse()
    |> result.unwrap(0)
  let part1 =
    parts
    |> list.last()
    |> result.unwrap("0")
    |> int.parse()
    |> result.unwrap(0)
  Range(part0, part1)
}

fn id_is_valid_pt1(id: String) -> Bool {
  let len = string.length(id)
  string.slice(id, 0, len / 2) != string.slice(id, len / 2, len)
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

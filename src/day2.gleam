import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam_community/maths
import simplifile

type Range(kind) {
  Range(min: kind, max: kind)
}

pub fn solve(input_path: String) -> #(Int, Int) {
  let assert Ok(content) = simplifile.read(from: input_path)
  io.println(content)
  content
  |> string.split(",")
  |> list.map(parse_range)
  |> list.fold(#(0, 0), fn(acc, range) {
    let invalid_sum =
      range
      |> viable_range()
      |> list.filter(fn(x) {
        x
        |> digits_count()
        |> int.is_even()
      })
      |> list.fold(0, fn(sum, id) {
        case id |> int.to_string() |> id_is_valid() {
          True -> sum
          False -> sum + id
        }
      })
    #(acc.0 + invalid_sum, acc.1)
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

fn viable_range(range: Range(Int)) -> List(Int) {
  case digits_count(range.min), digits_count(range.max) {
    len1, len2 if len1 == len2 && len1 % 2 != 0 -> list.new()
    _, _ -> list.range(range.min, range.max)
  }
}

fn digits_count(number: Int) -> Int {
  number
  |> int.to_float()
  |> maths.logarithm_10()
  |> result.unwrap(1.0)
  |> float.truncate()
  |> int.add(1)
}

fn id_is_valid(id: String) -> Bool {
  string.slice(id, 0, string.length(id) / 2)
  == string.slice(id, string.length(id) / 2, string.length(id))
}

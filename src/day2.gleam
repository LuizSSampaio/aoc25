import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn solve(input_path: String) -> #(Int, Int) {
  let assert Ok(content) = simplifile.read(from: input_path)
  content
  |> string.split(",")
  |> list.map(parse_range)
  |> list.fold(#(0, 0), fn(acc, range) { #(0, 0) })
}

fn parse_range(range: String) -> #(String, String) {
  let parts = string.split(range, "-")
  let part0 =
    parts
    |> list.first()
    |> result.unwrap("0")
  let part1 =
    parts
    |> list.last()
    |> result.unwrap("0")
  #(part0, part1)
}

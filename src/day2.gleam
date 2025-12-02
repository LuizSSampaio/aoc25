import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn solve(input_path: String) -> #(Int, Int) {
  let assert Ok(content) = simplifile.read(from: input_path)
  content |> string.split(",") |> list.map(parse_range)

  #(0, 0)
}

fn parse_range(range: String) -> #(Int, Int) {
  let parts = string.split(range, "-")
  let part0 =
    parts
    |> list.first()
    |> result.unwrap("0")
    |> int.parse()
    |> result.unwrap(0)
  let part1 =
    parts
    |> list.first()
    |> result.unwrap("0")
    |> int.parse()
    |> result.unwrap(0)
  #(part0, part1)
}

import gleam/bool
import gleam/int
import gleam/list
import gleam/string

pub fn normalize_newlines(input: String) -> String {
  string.replace(input, "\r\n", "\n")
}

pub fn lines(input: String) -> List(String) {
  let input = normalize_newlines(input)
  case string.ends_with(input, "\n") {
    True -> string.drop_end(input, 2)
    False -> input
  }
  |> string.split("\n")
}

pub fn parsed_lines(input: String, with fun: fn(String) -> a) -> List(a) {
  input |> lines() |> list.map(fun)
}

pub fn fields_by(input: String, by separator: String) -> List(String) {
  input
  |> string.trim()
  |> string.split(separator)
  |> list.map(string.trim)
  |> list.filter(fn(x) { x |> string.is_empty() |> bool.negate() })
}

pub fn parsed_fields_by(
  input: String,
  by separator: String,
  with fun: fn(String) -> a,
) -> List(a) {
  input |> fields_by(separator) |> list.map(fun)
}

pub fn line_fields_by(input: String, by separator: String) -> List(List(String)) {
  input |> lines() |> list.map(fields_by(_, separator))
}

pub fn parsed_line_fields_by(
  input: String,
  by separator: String,
  with fun: fn(String) -> a,
) -> List(List(a)) {
  input |> lines() |> list.map(parsed_fields_by(_, separator, fun))
}

pub fn unsafe_int_parse(input: String) -> Int {
  case int.parse(input) {
    Ok(val) -> val
    Error(Nil) -> panic as { "Invalid int value \"" <> input <> "\"" }
  }
}

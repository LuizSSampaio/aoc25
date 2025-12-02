import gleam/int

pub fn unsafe_parse(input: String) -> Int {
  case int.parse(input) {
    Ok(val) -> val
    Error(Nil) -> panic as { "Invalid int value \"" <> input <> "\"" }
  }
}

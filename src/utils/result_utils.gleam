pub fn unsafe_unwrap(x: Result(a, e)) -> a {
  case x {
    Ok(x) -> x
    Error(_) -> panic
  }
}

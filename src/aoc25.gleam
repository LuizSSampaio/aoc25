import day1
import gleam/int
import gleam/io

pub fn main() -> Nil {
  io.println("Day 1: " <> int.to_string(day1.solve()))
}

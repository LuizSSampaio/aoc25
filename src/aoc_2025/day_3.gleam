import gleam/bool
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/pair
import gleam/string
import utils/parse_utils
import utils/result_utils

pub fn parse(input: String) -> List(List(Int)) {
  input
  |> parse_utils.parsed_lines(fn(bank) {
    string.to_graphemes(bank) |> list.map(parse_utils.unsafe_int_parse)
  })
}

pub fn pt_1(banks: List(List(Int))) {
  use acc, bank <- list.fold(banks, 0)
  let batery_count = list.length(bank)
  let selection =
    list.fold(bank, #(0, 0, 0), fn(selected, volts) {
      let #(batery1, batery2, pos) = selected
      case int.compare(volts, batery1), int.compare(volts, batery2) {
        order.Gt, _ if pos < batery_count - 1 -> #(volts, 0, pos + 1)
        _, order.Gt -> #(batery1, volts, pos + 1)
        _, _ -> #(batery1, batery2, pos + 1)
      }
    })
  int.multiply(selection.0, 10) |> int.add(selection.1) |> int.add(acc)
}

pub fn pt_2(banks: List(List(Int))) {
  max_joltage(banks, 12)
}

fn max_joltage(banks: List(List(Int)), digits: Int) -> Int {
  use acc, bank <- list.fold(banks, 0)
  list.range(digits - 1, 0)
  |> list.fold(#(0, bank), fn(acc, i) {
    let #(val, bank) = acc
    let #(max, loc) =
      list.reverse(bank)
      |> list.drop(i)
      |> list.reverse()
      |> list.index_map(fn(n, i) { #(n, i) })
      |> list.max(fn(a, b) { int.compare(a.0, b.0) })
      |> result_utils.unsafe_unwrap()

    #(val * 10 + max, list.drop(bank, loc + 1))
  })
  |> pair.first()
  |> int.add(acc)
}

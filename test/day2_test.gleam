import day2

pub fn solve_test() {
  assert day2.solve("res/day2_example.txt") == #(1_227_775_554, 0)
  assert day2.solve("res/day2.txt").0 == 23_560_874_270
}

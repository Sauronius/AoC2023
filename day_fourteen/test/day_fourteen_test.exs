defmodule DayFourteenTest do
  use ExUnit.Case

  setup do
    file_content = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayFourteen.part_one("testfile.txt") == 136
  end

  test "test part 2" do
    assert DayFourteen.part_two("testfile.txt") == 64
  end
end

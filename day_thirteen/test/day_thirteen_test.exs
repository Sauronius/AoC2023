defmodule DayThirteenTest do
  use ExUnit.Case

  setup do
    file_content = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayThirteen.part_one("testfile.txt") == 405
  end

  test "test part 2" do
    assert DayThirteen.part_two("testfile.txt") == 400
  end
end

defmodule DayThreeTest do
  use ExUnit.Case

  setup do
    file_content = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayThree.part_one("testfile.txt") == 4361
  end

  test "test part 2" do
    assert DayThree.part_two("testfile.txt") == 467835
  end
end

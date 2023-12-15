defmodule DayElevenTest do
  use ExUnit.Case

  setup do
    file_content = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayEleven.part_one("testfile.txt") == 374
  end

  test "test part 2" do
    assert DayEleven.part_two("testfile.txt") == 82000210
  end
end

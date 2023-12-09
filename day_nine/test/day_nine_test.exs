defmodule DayNineTest do
  use ExUnit.Case

  setup do
    file_content = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayNine.part_one("testfile.txt") == 114
  end

  test "test part 2" do
    assert DayNine.part_two("testfile.txt") == 2
  end
end

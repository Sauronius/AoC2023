defmodule DayOneTest do
  use ExUnit.Case

  setup do
    File.write("testfile.txt", "oneenine\n222njninin\n3seightwe\n123456five789\n45twonenet\n")
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayOne.part_one("testfile.txt") == 119
  end

  test "test part 2" do
    assert DayOne.part_two("testfile.txt") == 139
  end
end

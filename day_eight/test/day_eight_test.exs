defmodule DayEightTest do
  use ExUnit.Case

  setup do
    file_content = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayEight.part_one("testfile.txt") == 6
  end

  test "test part 2" do
    assert DayEight.part_two("testfile.txt") == 6
  end
end

defmodule DaySevenTest do
  use ExUnit.Case

  setup do
    file_content = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DaySeven.part_one("testfile.txt") == 6440
  end

  test "test part 2" do
    assert DaySeven.part_two("testfile.txt") == 5905
  end
end

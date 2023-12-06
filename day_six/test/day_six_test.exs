defmodule DaySixTest do
  use ExUnit.Case

  setup do
    file_content = """
    Time:      7  15   30
    Distance:  9  40  200
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DaySix.part_one("testfile.txt") == 288
  end

  test "test part 2" do
    assert DaySix.part_two("testfile.txt") == 71503
  end
end

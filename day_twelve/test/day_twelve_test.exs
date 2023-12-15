defmodule DayTwelveTest do
  use ExUnit.Case

  setup do
    file_content = """
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayTwelve.part_one("testfile.txt") == 21
  end

  test "test part 2" do
    assert DayTwelve.part_two("testfile.txt") == 525152
  end
end

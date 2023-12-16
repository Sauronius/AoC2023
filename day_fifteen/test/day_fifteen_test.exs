defmodule DayFifteenTest do
  use ExUnit.Case

  setup do
    file_content = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
    File.write("testfile.txt", file_content)
    on_exit(fn -> File.rm!("testfile.txt") end)
  end

  test "test part 1" do
    assert DayFifteen.part_one("testfile.txt") == 1320
  end

  test "test part 2" do
    assert DayFifteen.part_two("testfile.txt") == 145
  end
end

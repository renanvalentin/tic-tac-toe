defmodule Engine.UITest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Engine.UI, as: UI
  alias Engine.Board, as: Board  

  def simple_test_data do
    [ "X", "O", "X",
      "O", "X", "O",
      "O", "X", "O"
    ]
  end

  def split_with_three_columns,
    do: Board.get_columns(simple_test_data())

  test "column_widths" do
    widths = UI.widths_of(split_with_three_columns())
    assert widths == [ 1, 1, 1 ]
  end

  test "correct format string returned" do
    assert UI.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "output is correct" do
    result = capture_io fn ->
      UI.print_board(simple_test_data())
    end
    
    assert result == """
    X | O | X
    O | X | O
    O | X | O
    """
  end
end

defmodule Engine.AITest do
  use ExUnit.Case

  alias Engine.AI, as: AI  

  test "next ai movement" do
    board = [
      "x", "x", "x",
      "x", "x", "x",
      "x", "x", nil
    ]

    assert AI.next_move(board) == %{row: 2, column: 2}
  end
end

defmodule Engine.BoardTest do
  use ExUnit.Case

  alias Engine.Board, as: Board  

  test "setup board size" do
    assert Board.make_board == [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ]
  end

  test "place player position on the board" do
    board = [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ]

    updated_board = Board.place(board, %{row: 1, column: 1}, :x)

    assert updated_board == [
                 nil, nil, nil,
                 nil, :x, nil,
                 nil, nil, nil
                ]
  end

  test "board rows" do
    board = [
      "r1c1", "r1c2", "r1c3",
      "r2c1", "r2c2", "r2c3",
      "r3c1", "r3c2", "r3c3"
    ]

    assert Board.get_rows(board) == [
                  ["r1c1", "r1c2", "r1c3"],
                  ["r2c1", "r2c2", "r2c3"],
                  ["r3c1", "r3c2", "r3c3"]
                ]
  end

  test "board columns" do
    board = [
      "r1c1", "r1c2", "r1c3",
      "r2c1", "r2c2", "r2c3",
      "r3c1", "r3c2", "r3c3"
    ]

    assert Board.get_columns(board) == [
                  ["r1c1", "r2c1", "r3c1"],
                  ["r1c2", "r2c2", "r3c2"],
                  ["r1c3", "r2c3", "r3c3"]
                ]
  end

  test "left to right diagonal board" do
    board = [
      "r1c1", "r1c2", "r1c3",
      "r2c1", "r2c2", "r2c3",
      "r3c1", "r3c2", "r3c3"
    ]

    assert Board.from_left_to_right_diagonal(board) == [
                  "r1c1", "r2c2", "r3c3"
                ]
  end

  test "right to left diagonal board" do
    board = [
      "r1c1", "r1c2", "r1c3",
      "r2c1", "r2c2", "r2c3",
      "r3c1", "r3c2", "r3c3"
    ]

    assert Board.from_right_to_left_diagonal(board) == [
                  "r1c3", "r2c2", "r3c1"
                ]
  end

  test "board diagonals" do
    board = [
      "r1c1", "r1c2", "r1c3",
      "r2c1", "r2c2", "r2c3",
      "r3c1", "r3c2", "r3c3"
    ]

    assert Board.get_diagonals(board) == [
                  ["r1c1", "r2c2", "r3c3"],
                  ["r1c3", "r2c2", "r3c1"]
                ]
  end

  test "check for winner on vertical column" do
    board = [
      nil, nil, :x,
      nil, nil, :x,
      nil, nil, :x
    ]

    assert Board.winner?(board) == true
  end

  test "check for winner on horizontal column" do
    board = [
      nil, nil, nil,
      :x, :x, :x,
      nil, nil, nil
    ]

    assert Board.winner?(board) == true
  end

  test "check for winner on left diagonal" do
    board = [
      :x, nil, nil,
      nil, :x, nil,
      nil, nil, :x
    ]

    assert Board.winner?(board) == true
  end

  test "check for winner on right diagonal" do
    board = [
      nil, nil, :x,
      nil, :x, nil,
      :x, nil, nil
    ]

    assert Board.winner?(board) == true
  end

  test "available positions" do
    board = [
      nil, nil, :x,
      nil, :x, nil,
      :x, nil, nil
    ]

    assert Board.can_place?(board, %{row: 1, column: 1}) == false
  end

  test "board is full" do
    board = [
      :x, :o, :x,
      :o, :x, :o,
      :x, :x, :o
    ]

    assert Board.full?(board) == true
  end

  test "draw result" do
    board = [
      :x, :o, :x,
      :o, :x, :o,
      :o, :x, :o
    ]

    assert Board.resolve_winner(board) == :draw
  end

  test "available cells" do
    board = [
      :x, :o, :x,
      :o, nil, :o,
      :o, :x, :o
    ]

    assert Board.available_positions(board) == [%{row: 1, column: 1}]
  end
end

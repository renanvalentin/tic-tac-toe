defmodule Engine.AI do
  alias Engine.Board, as: Board    

  def next_move(board) do
    Board.available_positions(board)
    |> Enum.take_random(1)
    |> List.first
  end
end
defmodule Engine.Board do
  
  @board_size Application.get_env :tic_tac, :board_size

  def make_board do
    Enum.map(1..@board_size*@board_size, &(&1 = nil))
  end

  def can_place?(board, %{row: row, column: column}) do
    Enum.fetch!(board, get_index(row, column)) == nil
  end

  def full?(board) do
    board
    |> Enum.all?(fn position -> position != nil end)
  end

  def resolve_winner(board) do
    cond do
      winner?(board) ->
          :winner
      full?(board) ->
          :draw
      true ->
          :no_result
      end
  end

  def winner?(board) do
    group_board(board)
    |> Enum.any?(fn group -> check_winner?(group) end)
  end

  defp check_winner?(group) do
    uniques = Enum.uniq(group)

    Enum.count(uniques) == 1 and List.first(uniques) != nil
  end

  defp group_board(board) do
    get_rows(board) ++ get_columns(board) ++ get_diagonals(board)
  end

  def place(board, %{row: row, column: column}, player) do
    List.replace_at(board, get_index(row, column), player)
  end

  def get_index(row, column), do: row * @board_size + column 

  def get_rows(board), do: Enum.chunk(board, @board_size)

  def get_columns(board) do
    Enum.map(0..@board_size - 1, &(get_column(&1, board)))
  end

  def get_column(column, board) do
    board
    |> Enum.drop(column)
    |> Enum.take_every(@board_size)
  end

  def get_diagonals(board) do
    [from_left_to_right_diagonal(board) | [from_right_to_left_diagonal(board)]]
  end

  def from_left_to_right_diagonal(board) do
    Stream.iterate(0, fn index -> index + @board_size + 1 end)
    |> Enum.take(@board_size)
    |> get_diagonal(board)
  end

  def from_right_to_left_diagonal(board) do
    Stream.iterate(@board_size - 1, fn index -> index + @board_size - 1 end)
    |> Enum.take(@board_size)
    |> get_diagonal(board)
  end

  def get_diagonal(diagonal_indexes, board) do
    for diagonal_indexes <- diagonal_indexes, do: Enum.at(board, diagonal_indexes)
  end

  def available_positions(board) do
    for position <- decompound_positions(board), {mark, index} = position,
    !position_occupied?(mark) do
        row_column(index)
    end
  end

  defp position_occupied?(mark), do: mark != nil

  defp decompound_positions(board) do
      board |> Enum.with_index
  end

  defp row_column(index) do
      %{row: div(index, @board_size), column: rem(index, @board_size)}
  end
end
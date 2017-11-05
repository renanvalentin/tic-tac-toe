defmodule Engine.UI do
  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1]

  alias Engine.Board, as: Board  

  def print_board(board) do
    non_empty_board = prepare_board(board)
    with data_by_columns = Board.get_columns(non_empty_board),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
      puts_in_columns(data_by_columns, format)
    end
  end

  defp prepare_board(board) do
    for cell <- board do
      if cell != nil do
        cell
      else
        " "
      end
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do 
    for column <- columns do
      column
      |> map(&String.length/1)
      |> max
    end
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end

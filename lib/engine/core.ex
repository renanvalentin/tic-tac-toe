defmodule Engine.Core do
  
  @player_1 Application.get_env :tic_tac, :player_1
  @player_2 Application.get_env :tic_tac, :player_2  
  @terminator Application.get_env :tic_tac, :terminator

  alias Engine.Board, as: Board    
  alias Engine.State, as: State    

  def start_game() do
      %State{board: Board.make_board}
  end

  def move(state, place) do
    case validate_entry(place, state.board) do
      {:error, msg} ->
        {:error, msg}
      true ->
        update_state(state, place)
    end
  end

  def update_state(state, place) do
    board = Board.place(state.board, place, player_symbol(state.next_player))

    case Board.resolve_winner(board) do
      :winner ->
        %State{state | game_over: true, winner: state.next_player, board: board}
      :draw ->
        %State{state | game_over: true, board: board}
      :no_result ->
        %State{state | next_player: swap_player(state.next_player), board: board}
    end
  end

  defp validate_entry(place, board) do
    cond do
      Board.can_place?(board, place) == false ->
        {:error, "can't place it here :("}
      true ->
        true
    end
  end

  def player_symbol(:player_1), do: @player_1
  def player_symbol(:player_2), do: @player_2
  def player_symbol(:terminator), do: @terminator

  def swap_player(:player_1), do: :player_2
  def swap_player(:player_2), do: :terminator
  def swap_player(:terminator), do: :player_1
end
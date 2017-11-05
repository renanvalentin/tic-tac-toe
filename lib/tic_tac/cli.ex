defmodule TicTac.Cli do
  alias Engine.Game, as: Game  
  alias Engine.Core, as: Core  
  alias Engine.UI, as: UI  
  alias Engine.State, as: State    
  alias Engine.AI, as: AI    

  @board_size Application.get_env :tic_tac, :board_size
  
  def main(_args) do
    game = Game.start_game()
    state = Game.game_state(game)
  
    draw(state)
    
    game_loop(game)
  end

  defp game_loop(game) do
    state = Game.game_state(game)
    
    cond do
      state.game_over ->
        winner(state)
      true ->
        play(game, state)
    end
  end

  def winner(%State{winner: nil, game_over: true}), do: IO.puts "Draw!"
  
  def winner(%State{winner: winner, game_over: true}) do
    player_symbol = Core.player_symbol(winner)
    IO.puts "Player #{player_symbol} won!"
  end

  def play(game, %State{next_player: :terminator, board: board}) do
    player_symbol = Core.player_symbol(:terminator)
    IO.puts "#{player_symbol} turns!"
    IO.puts "Watch out!"

    next_move = AI.next_move(board)
    next_state = Game.move(game, next_move)

    draw(next_state)
    game_loop(game)
  end

  def play(game, state) do
    player_symbol = Core.player_symbol(state.next_player)
    cmd = IO.gets "Player #{player_symbol}: "

    input = String.upcase(String.trim(cmd))

    next_state = handle_move(input, game)
    draw(next_state)
    
    game_loop(game)
  end

  def draw(state) do
    IO.puts "\n"
    UI.print_board(state.board)    
    IO.puts "\n"
  end

  def handle_move(move, game) do
    case valid_input?(move) do
      true ->
        handle_valid_movement(move, game)
      _ ->
        handle_invalid_movement(game)
    end
  end

  def handle_valid_movement(move, game) do
    Game.move(game, parse_move(move))
  end

  def handle_invalid_movement(game) do
    display_valid_inputs()
    
    Game.game_state(game)
  end

  def display_valid_inputs do
    IO.puts("Please, use the following pattern row,column. e.g: 1,2")
  end

  def valid_input?(input) do
    case Regex.match?(~r/^[0-9],[0-9]$/, input) do
      true ->
        move = parse_move(input)
        valid_bondaries?(move.row) and valid_bondaries?(move.column)
      _ ->
        false
    end
  end

  defp parse_move(move) do
    [row, column] = String.split(move, ",")
    %{row: String.to_integer(row) - 1, column: String.to_integer(column) - 1}
  end

  defp valid_bondaries?(move) do
    move >= 0 and move < @board_size 
  end
end

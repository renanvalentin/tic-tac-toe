defmodule Engine.State do
  defstruct next_player: :player_1, 
            board: nil,
            game_over: nil,
            winner: nil
end
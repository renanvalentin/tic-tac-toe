defmodule Engine.GameTest do
  use ExUnit.Case, async: true

  @player_1 Application.get_env :tic_tac, :player_1

  alias Engine.Game, as: Game

  test "start an Agent that maintains the game state" do
    game = Game.start_game()
    state = Agent.get(game, fn state -> state end)

    assert is_pid game
    assert is_map state
    assert ! state.game_over
  end

  test "update the state maintained by game agent" do
    game = Game.start_game()
    Game.move(game, %{row: 1, column: 1})
    
    new_state = Agent.get(game, fn state -> state end)

    assert new_state.next_player == :player_2
    assert new_state.board == [
      nil, nil, nil,
      nil, @player_1, nil,
      nil, nil, nil
    ]
  end
end

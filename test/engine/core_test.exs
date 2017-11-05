defmodule Engine.CoreTest do
  use ExUnit.Case

  @player_1 Application.get_env :tic_tac, :player_1
  @player_2 Application.get_env :tic_tac, :player_2  

  alias Engine.Core, as: Core  
  alias Engine.State, as: State    

  test "init game state" do
    assert Core.start_game() == %State{
      board: [
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ]
    } 
  end

  test "validate player movement" do
    state = %State{
      board: [
        :x, :x, :y,
        :y, :y, :x,
        :x, :y, :x
      ],
      next_player: :player_1
    }

    place = %{row: 1, column: 2}

    assert Core.move(state, place) == {:error, "can't place it here :("}
  end

  test "update game state" do
    state = %State{
      board: [
        nil, nil, nil,
        nil, nil, nil,
        nil, nil, nil
      ],
      next_player: :player_1
    }
    
    place = %{row: 1, column: 1}

    assert Core.move(state, place) == %State{
      state |
      board: [
        nil, nil, nil,
        nil, @player_1, nil,
        nil, nil, nil
      ],
      next_player: :player_2
    }
  end

  test "end game when there is a draw" do
    state = %State{
      board: [
        @player_1, @player_1, @player_2,
        @player_2, @player_2, @player_1,
        @player_1, @player_2, nil
      ],
      next_player: :player_1
    }
    
    place = %{row: 2, column: 2}

    assert Core.move(state, place) == %State{
      state |
      board: [
        @player_1, @player_1, @player_2,
        @player_2, @player_2, @player_1,
        @player_1, @player_2, @player_1
      ],
      game_over: true
    }
  end

  test "swap to player 2 when player 1 is done" do
    assert Core.swap_player(:player_1) == :player_2
  end

  test "swap to terminator when player 2 is done" do
    assert Core.swap_player(:player_2) == :terminator
  end

  test "swap to player 1 when terminator is done" do
    assert Core.swap_player(:terminator) == :player_1
  end
end

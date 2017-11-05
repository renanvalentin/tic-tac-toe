defmodule Engine.Game do
  alias Engine.Core, as: Core  

  def start_game() do
    initial_state = Core.start_game()
    start_link(initial_state)
  end

  defp start_link(initial_state) do
    {:ok, pid} = Agent.start_link(fn -> initial_state end)
    pid
  end

  def move(game, place) do
    state = game_state(game)

    case Core.move(state, place) do
      {:error, msg} ->
        IO.puts msg
        state
      next_state ->
        Agent.update(game, fn _state -> next_state end)
        next_state
    end
  end

  def game_state(game) do
    Agent.get(game, fn state -> state end)
  end
end

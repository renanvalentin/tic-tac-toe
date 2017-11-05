defmodule TicTac.CliTest do
  use ExUnit.Case

  alias TicTac.Cli, as: Cli  

  test "make sure that only valid combinations get accepted as moves" do
    assert Cli.valid_input?("1,2") == true
    assert Cli.valid_input?("1,10") == false
    assert Cli.valid_input?("1, 2") == false
  end
end

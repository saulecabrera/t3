defmodule T3.GameTest do 
  alias T3.{GameRegistry, Game, GameSupervisor}
  use ExUnit.Case, async: true

  setup do
    start_supervised!(GameRegistry)
    start_supervised!(GameSupervisor)
    {:ok, game} = GameSupervisor.start_child({Game, "setup"})
    %{game: game}
  end

  describe "Game.add_player/1" do
    test "it adds a player to the game; returns error if all players have been set", %{game: game} do
      assert :ok = game |> Game.add_player
      assert {:error, _} = game |> Game.add_player

      IO.inspect Registry.lookup(GameRegistry, "setup")
    end
  end

  describe "Game.add_mark/2" do
    test "it prevents adding a mark unless both players are set", %{game: game} do
      assert {:error, _} = Game.add_mark(game, coords: {1, 1}, player: 1) 
    end

    test "it adds a mark to the board and returns a game status", %{game: game} do
      game |> Game.add_player
      assert :ok = game |> Game.add_mark(coords: {1, 1}, player: 1)
      game |> Game.add_mark(coords: {2, 1}, player: 2)
      game |> Game.add_mark(coords: {2, 2}, player: 1)
      game |> Game.add_mark(coords: {2, 3}, player: 2)
      assert {:win, 1} = game |> Game.add_mark(coords: {3, 3}, player: 1)

      %{rules: rules} = :sys.get_state(game)
      assert rules.next_player.turn == 1
    end

    test "it validates that players respect their turn", %{game: game} do
      game |> Game.add_player
      game |> Game.add_mark(coords: {1, 1}, player: 1) 
      assert {:error, _} = game |> Game.add_mark(coords: {1, 1}, player: 1) 
    end
  end
end

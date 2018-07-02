defmodule T3.RulesTest do
  alias T3.{Rules, Player}
  use ExUnit.Case, async: true

  setup do
    [rules: Rules.new]
  end


  test "Rules.new/0 returns empty rules", context do
    assert context.rules.players == []
    assert context.rules.next_player == nil
    assert context.rules.players_set? == false
  end

  describe "Rules.validate/2" do
    test "it validates adding players", context do
      {:ok, rules} = context.rules |> Rules.validate(:add_player)
      assert rules = %Rules{players: [%Player{turn: 1, mark: :x}]}
      {:ok, rules} = rules |> Rules.validate(:add_player)
      assert rules = %Rules{players: [%Player{turn: 1, mark: :x}, %Player{turn: 2, mark: :o}]}
      assert {:error, _} = rules |> Rules.validate(:add_player)
    end

    test "it validates and toggles turns only after all players are set", context do
      {:ok, rules} = context.rules |> Rules.validate(:add_player)
      {:ok, rules} = rules |> Rules.validate(:add_player)

      assert rules.players_set?
      assert rules.next_player

      {:ok, rules} = rules |> Rules.validate({:turn, 1})
      assert rules.next_player == List.last(rules.players)

      {:ok, rules} = rules |> Rules.validate({:turn, 2})
      assert rules.next_player == List.first(rules.players)

      assert {:error, _} = rules |> Rules.validate({:turn, 2})

      assert {:error, :missing_players} = context.rules |> Rules.validate({:turn, 1})
    end
  end
end

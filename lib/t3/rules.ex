defmodule T3.Rules do
  alias T3.{Rules, Player}

  defstruct players: [], next_player: nil, players_set?: false

  def new do
    %Rules{}
  end

  def validate(rules = %Rules{players: []}, :add_player) do
    {:ok, %Rules{rules | players: [Player.new(1, :x)]}}
  end

  def validate(rules = %Rules{players: [h]}, :add_player) do
    {:ok, %Rules{rules | players: [h, Player.new(2, :o)], players_set?: true, next_player: h}}
  end

  def validate(%Rules{players: _players}, :add_player), do: {:error, :invalid_player_count}

  def validate(rules = %Rules{players_set?: true}, {:turn, turn}) do
    [first, second] = rules.players
    cond do
      rules.next_player.turn == turn ->
        {:ok, %Rules{rules | next_player: if(turn == 1, do: second, else: first)}}
      true ->
        {:error, :invalid_turn}
    end
  end

  # TODO: raise?
  def validate(%Rules{players_set?: false}, {:turn, _}), do: {:error, :missing_players}
end

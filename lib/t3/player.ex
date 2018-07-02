defmodule T3.Player do
  alias T3.Player

  @enforce_keys [:turn, :mark]
  defstruct [:turn, :mark]

  def new(turn, mark) do
    %Player{turn: turn, mark: mark}
  end
end

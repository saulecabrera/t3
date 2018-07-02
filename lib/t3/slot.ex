defmodule T3.Slot do
  alias __MODULE__

  @enforce_keys [:coords]
  @valid_marks [:x, :o]

  defstruct [:coords, :mark]

  def new({x, y}) when is_integer(x) and is_integer(y), do: {:ok, %Slot{coords: {x, y}}}
  def new(_), do: {:error, :invalid_coords}

  def mark(%Slot{mark: nil} = slot, mark) when mark in @valid_marks, do: {:ok, %Slot{ slot | mark: mark }}
  def mark(_, _), do: {:error, :invalid_mark}

  def empty?(%Slot{mark: nil}), do: true
  def empty?(%Slot{}), do: false
end

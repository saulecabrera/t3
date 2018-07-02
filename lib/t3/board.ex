defmodule T3.Board do

  alias T3.{Slot, Board}
  defstruct [:slots]

  @slots [
    {1, 1}, {1, 2}, {1, 3},
    {2, 1}, {2, 2}, {2, 3},
    {3, 1}, {3, 2}, {3, 3},
  ]

  @wins [
    [{1, 1}, {1, 2}, {1, 3}],
    [{2, 1}, {2, 2}, {2, 3}],
    [{3, 1}, {3, 2}, {3, 3}],

    [{1, 1}, {2, 1}, {3, 1}],
    [{1, 2}, {2, 2}, {3, 2}],
    [{1, 3}, {2, 3}, {3, 3}],

    [{1, 1}, {2, 2}, {3, 3}],
    [{3, 1}, {2, 2}, {1, 3}],
  ]

  for slot <- @slots do
    wins_for_slot = Enum.filter(@wins, fn win -> slot in win end)
    def wins(unquote(slot)) do
      unquote(wins_for_slot)
    end
  end

  def new do
    %Board{
      slots: MapSet.new(@slots, fn coords ->
        {:ok, slot} = Slot.new(coords)
        slot
      end)
    }
  end

  def mark(board = %Board{slots: slots}, x, y, mark) do
    with slot = %Slot{} <- find_slot_by_coords(slots, {x, y}),
         true <- Slot.empty?(slot),
         {:ok, slot} <- Slot.mark(slot, mark),
         board = %Board{} <- update(board, slot) do
      {check(board, slot), board}
    else
      nil ->
        {:error, :slot_not_found}
      false ->
        {:error, :non_empty_slot}
      e ->
        e
    end
  end 

  defp update(board, %Slot{coords: coords} = slot) do
    slots = MapSet.new(board.slots, fn
      %Slot{coords: ^coords} -> slot
      current -> current
    end)
    %Board{board | slots: slots}
  end

  defp find_slot_by_coords(slots, coords) do
    Enum.find(slots, fn slot -> slot.coords == coords end)
  end

  defp check(%Board{slots: slots}, %Slot{} = last_move) do
    winning_sequences = wins(last_move.coords)
    case Enum.filter(winning_sequences, fn seq -> winning_sequence?(slots, seq) end) do
      [] ->
        if Enum.all?(slots, fn slot -> slot.mark != nil end) do
          :tie
        else
          :ok
        end
      _ ->
        :win
    end
  end

  defp winning_sequence?(board_slots, sequence) do
    case Enum.filter(board_slots, fn slot -> slot.coords in sequence end) do
      [%Slot{mark: mark}, %Slot{mark: mark}, %Slot{mark: mark}] when mark == :x ->
        true
      [%Slot{mark: mark}, %Slot{mark: mark}, %Slot{mark: mark}] when mark == :o ->
        true
      _ ->
        false
    end
  end
end

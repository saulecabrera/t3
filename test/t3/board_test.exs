defmodule T3.BoardTest do
  alias T3.{Board, Slot}
  use ExUnit.Case, async: true

  setup do
    [board: Board.new]
  end

  test "Board.new/0 creates a new board with 9 empty slots", context do
    board = context.board
    assert MapSet.size(board.slots) == 9
    Enum.each(board.slots, fn %Slot{mark: mark} -> assert mark == nil end)
  end

  describe "Board.mark/4" do
    test "it returns {:ok, board} when the mark is set successfully", context do
      assert {:ok, board} = Board.mark(context.board, 1, 1, :x)
      assert %Slot{mark: :x} = Enum.find(board.slots, fn slot -> slot.mark === :x end)
    end

    test "it returns {:error, :slot_not_found} when trying to mark an unknown slot", context do
      assert {:error, :slot_not_found} = Board.mark(context.board, 10, 10, :x)
    end

    test "it returns {:error, :non_empty_slot} when trying to mark a slot that has already been taken", context do
      {:ok, board} = Board.mark(context.board, 1, 1, :x)
      assert {:error, :non_empty_slot} = Board.mark(board, 1, 1, :x)
    end

    test "it returns {:error, invalid_mark} when trying to use a mark other than x or o", context do
      {:error, :invalid_mark} = Board.mark(context.board, 1, 1, :foo)
    end

    test "it returns {:win, board} when a winning sequence is present", context do
      {:ok, board} = Board.mark(context.board, 2, 2, :x)
      {:ok, board} = Board.mark(board, 1, 1, :x)
      {:win, _} = Board.mark(board, 3, 3, :x)
    end

    test "it returns {:tie, board} when the board is complete and there's no winning sequence", context do
      slots = [
        {1, 1, :x}, {1, 2, :o}, {1, 3, :x},
        {2, 1, :x}, {2, 2, :o}, {2, 3, :x},
        {3, 1, :o}, {3, 2, :x},
      ]

      board = Enum.reduce(slots, context.board, fn
        {x, y, mark}, board ->
          {:ok, board} = Board.mark(board, x, y, mark)
          board
      end)

      assert {:tie, _} = Board.mark(board, 3, 3, :o)
    end
  end
end

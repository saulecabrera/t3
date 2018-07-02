defmodule T3.Game do
  @moduledoc false

  alias T3.{Board, Rules, GameRegistry}
  require Logger
  use GenServer, restart: :temporary

  def start_link(game_id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(game_id))
  end

  def add_mark(game, coords: coords, player: player), do: GenServer.call(game, {:add_mark, coords, player})

  def add_player(game), do: GenServer.call(game, :add_player)

  defp via_tuple(name), do: GameRegistry.via_tuple(name)

  # Server

  @impl true
  def init(_) do
    {:ok, rules} = Rules.new |> Rules.validate(:add_player)
    {:ok, %{board: Board.new, rules: rules}}
  end

  @impl true
  def handle_call({:add_mark, {x, y}, player}, _from, state = %{rules: %Rules{players_set?: true}}) do
    with {:ok, rules} <- Rules.validate(state.rules, {:turn, player}) do
      case Board.mark(state.board, x, y, state.rules.next_player.mark) do
        {:win, board} ->
          reply {:win, player}, %{state | board: board}
        {result, board} when result == :ok or result == :tie ->
          reply result, %{state | board: board, rules: rules}
        e ->
          reply e, state
      end
    else
      e ->
        reply e, state
    end
  end

  @impl true
  def handle_call({:add_mark, _, _}, _, state = %{rules: %Rules{players_set?: false}}) do
    reply {:error, :missing_players}, state
  end

  @impl true
  def handle_call(:add_player, _, state) do
    case Rules.validate(state.rules, :add_player) do
      {:ok, rules} ->
        reply :ok, %{state | rules: rules}
      e ->
        reply e, state
    end
  end

  def handle_info(msg, state) do
    Logger.info fn ->
      "#{IO.inspect(__MODULE__)}@#{self()} received info: \n #{IO.inspect(msg)}"
    end

    {:noreply, state}
  end

  defp reply(msg, state), do: {:reply, msg, state}
end

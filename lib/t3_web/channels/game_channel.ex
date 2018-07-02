defmodule T3Web.GameChannel do
  alias T3.{Game, GameRegistry} 
  use Phoenix.Channel

  def join("game:" <> game_id, _params, socket) do
    with [{pid, _}] <- GameRegistry.lookup(game_id),
         :ok <- Game.add_player
    do
      {:ok, assign(socket, [game: pid, turn: 2])}
    else
      [] ->
        {:ok, pid} = GameSupervisor.start_child({Game, game_id})
        {:ok, assign(socket, [game: pid, turn: 1])}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  def handle_in("mark", %{"x" => x, "y" => y}, socket) do
  end

  defp assign(socket, opts) do
    Enum.reduce(opts, socket, fn {k, v}, acc ->
      assign(acc, k, v)
    end)
  end
end

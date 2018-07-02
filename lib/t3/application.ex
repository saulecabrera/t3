defmodule T3.Application do
  alias T3.{GameRegistry, GameSupervisor}
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(T3Web.Endpoint, []),
      GameRegistry,
      GameSupervisor 
    ]

    opts = [strategy: :one_for_one, name: T3.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    T3Web.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Interview do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Interview.DecisionRegistry},
      Interview.DecisionSupervisor
    ]

    opts = [strategy: :one_for_one, name: Interview.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

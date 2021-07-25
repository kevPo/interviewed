defmodule Interview.DecisionSupervisor do
  use DynamicSupervisor

  alias Interview.DecisionServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_decision(name, number_of_voters) do
    child_spec = %{
      id: DecisionServer,
      start: {DecisionServer, :start_link, [name, number_of_voters]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def stop(name) do
    child_pid = DecisionServer.game_pid(name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end

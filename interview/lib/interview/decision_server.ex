defmodule Interview.DecisionServer do
  use GenServer

  @timeout :timer.hours(2)

  def start_link(name, number_of_voters) do
    GenServer.start_link(
      __MODULE__,
      {name, number_of_voters},
      name: via_tuple(name)
    )
  end

  def vote(name, vote) do
    GenServer.call(via_tuple(name), {:vote, vote})
  end

  def via_tuple(name) do
    {:via, Registry, {Interview.DecisionRegistry, name}}
  end

  def game_pid(name) do
    name
    |> via_tuple()
    |> GenServer.whereis()
  end

  # Server Callbacks

  def init({name, number_of_voters}) do
    decision = Interview.Decision.new(name, number_of_voters)

    {:ok, decision, @timeout}
  end

  def handle_call({:vote, vote}, _from, decision) do
    updated_decision = Interview.Decision.vote(decision, vote)

    {:reply, updated_decision, updated_decision, @timeout}
  end

  def handle_info(:timeout, game) do
    {:stop, {:shutdown, :timeout}, game}
  end
end

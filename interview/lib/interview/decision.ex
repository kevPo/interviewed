defmodule Interview.Decision do
  defstruct(
    name: nil,
    soft_yes: 0,
    hard_yes: 0,
    soft_no: 0,
    hard_no: 0,
    total_votes: 0,
    number_of_voters: 0,
    team_choice: nil
  )

  alias Interview.Decision

  def new(name, number_of_voters) do
    %Decision{name: name, number_of_voters: number_of_voters}
  end

  def vote(decision = %{soft_yes: soft_yes, total_votes: total_votes}, :soft_yes) do
    %{decision | soft_yes: soft_yes + 1, total_votes: total_votes + 1}
    |> make_decision(total_votes + 1 == decision.number_of_voters)
  end

  def vote(decision = %{soft_no: soft_no, total_votes: total_votes}, :soft_no) do
    %{decision | soft_no: soft_no + 1, total_votes: total_votes + 1}
    |> make_decision(total_votes + 1 == decision.number_of_voters)
  end

  def vote(decision = %{hard_yes: hard_yes, total_votes: total_votes}, :hard_yes) do
    %{decision | hard_yes: hard_yes + 1, total_votes: total_votes + 1}
    |> make_decision(total_votes + 1 == decision.number_of_voters)
  end

  def vote(decision = %{hard_no: hard_no, total_votes: total_votes}, :hard_no) do
    %{decision | hard_no: hard_no + 1, total_votes: total_votes + 1}
    |> make_decision(total_votes + 1 == decision.number_of_voters)
  end

  def make_decision(decision = %{hard_no: hard_no, hard_yes: hard_yes}, true)
      when hard_no > 0 or hard_yes == 0 do
    %{decision | team_choice: false}
  end

  def make_decision(decision, true) do
    %{decision | team_choice: decision.hard_yes * 2 + decision.soft_yes > decision.soft_no}
  end

  def make_decision(decision, _) do
    decision
  end
end

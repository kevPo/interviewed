defmodule DecisionTest do
  use ExUnit.Case
  doctest Interview.Decision

  alias Interview.Decision

  test "decision is created correctly" do
    decision = Decision.new("Test", 2)

    assert decision.name == "Test"
    assert decision.number_of_voters == 2
    assert decision.total_votes == 0
    assert decision.hard_yes == 0
    assert decision.soft_yes == 0
    assert decision.hard_no == 0
    assert decision.soft_no == 0
    assert decision.team_choice == nil
  end

  test "votes are added" do
    decision =
      Decision.new("Test", 4)
      |> Decision.vote(:hard_yes)
      |> Decision.vote(:soft_yes)
      |> Decision.vote(:hard_no)
      |> Decision.vote(:soft_no)

    assert decision.total_votes == 4
    assert decision.hard_yes == 1
    assert decision.soft_yes == 1
    assert decision.hard_no == 1
    assert decision.soft_no == 1
  end

  test "one hard no vote set choice to false" do
    decision =
      Decision.new("Test", 1)
      |> Decision.vote(:hard_no)

    refute decision.team_choice
  end

  test "no hard yes vote sets choice to false" do
    decision =
      Decision.new("Test", 1)
      |> Decision.vote(:soft_yes)

    refute decision.team_choice
  end

  test "if soft no votes are equal to soft yes and hard yes then choice is false" do
    decision =
      Decision.new("Test", 3)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:hard_yes)

    refute decision.team_choice
  end

  test "if soft no votes are greater than soft yes and hard yes then choice is false" do
    decision =
      Decision.new("Test", 4)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:hard_yes)

    refute decision.team_choice
  end

  test "if soft no votes are less than soft yes and hard yes then choice is true" do
    decision =
      Decision.new("Test", 4)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:soft_no)
      |> Decision.vote(:soft_yes)
      |> Decision.vote(:hard_yes)

    assert decision.team_choice
  end
end

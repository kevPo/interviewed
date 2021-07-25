defmodule InterviewTest do
  use ExUnit.Case
  doctest Interview

  test "greets the world" do
    assert Interview.hello() == :world
  end
end

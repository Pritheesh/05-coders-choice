defmodule UserStoreTest do
  use ExUnit.Case
  doctest UserStore

  test "greets the world" do
    assert UserStore.hello() == :world
  end
end

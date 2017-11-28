defmodule Ds.DsTest do
  use ExUnit.Case

  test "integrity and authenticity are satisfied" do
    assert { :ok, :ok } == UserStore.register { "Pri", "Asdasd!23" }
    { _message, digest } = Ds.sign({ :password, "pri", "Asdasd!23", "hello" })
    { :ok, key } = UserStore.get_public_key("pri")
    assert { :safe, "hello" } == Ds.verify({ "hello", digest, key} )
  end

  test "Someone changed my message :(" do
    assert { :ok, :ok } == UserStore.register { "Pra", "Asdasd!23" }
    { _message, digest } = Ds.sign({ :password, "pra", "Asdasd!23", "hello" })
    { :ok, key } = UserStore.get_public_key("pra")
    assert { :danger, "lol" } == Ds.verify({ "lol", digest, key })
  end

end

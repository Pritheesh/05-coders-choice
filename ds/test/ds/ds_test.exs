defmodule Ds.DsTest do
  use ExUnit.Case

  test "integrity and authenticity are satisfied" do
    assert { :ok, :ok } == UserStore.register {"Pri", "Asdasd!23"}
    {_message, digest} = Ds.generate_ds({"pri", "Asdasd!23", "hello"})
    assert true == Ds.Generator.compare({"hello", digest}, "pri")
  end

  test "Someone changed my message :(" do
    assert { :ok, :ok } == UserStore.register {"Pra", "Asdasd!23"}
    {_message, digest} = Ds.generate_ds({"pra", "Asdasd!23", "hello"})
    assert false == Ds.Generator.compare({"lol", digest}, "pra")
  end

end

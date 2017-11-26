defmodule UserStore.UserStoreTest do
  use ExUnit.Case

  test "user created" do
    assert { :ok, :ok } == UserStore.register {"Pri", "Asdasd!23"}
    assert "pri" in UserStore.display
  end

  test "check username error" do
    { :error, error } = UserStore.register({"Pr", "asdasd"})
    assert "username is too short." == error
  end

  test "check password error" do
    { :error, error } = UserStore.register({"Pra", "asdasd"})
    assert "Password must contain at least 1 lowercase letter, 1 uppercase letter, 1 special " <>
           "character, 1 number and minimum length of 8" == error
  end

  test "user already exists" do
    assert { :ok, :ok } = UserStore.register {"Prod", "Asdasd!23"}
    assert { :error, error } = UserStore.register {"Prod", "Asdasd!23"}
    assert "User with given username already exists. Please try again." == error
  end

  test "check private key" do
    assert { :ok, :ok } = UserStore.register {"Prim", "Asdasd!23"}
    { :ok, key } = UserStore.get_private_key({"prim", "Asdasd!23"})
    assert key != nil
  end

  test "check public key" do
    assert { :ok, :ok } = UserStore.register {"lad", "Asdasd!23"}
    { :ok, key } = UserStore.get_public_key "lad"
    assert key != nil
  end

  test "check public key error" do
    { :error, error } = UserStore.get_public_key "lid"
    assert error == "Invalid username. Please enter correct username."
  end

  test "check private key error" do
    { :error, error } = UserStore.get_private_key {"lid", "asdasd"}
    assert error == "Invalid credentials. Please try again."
  end

end

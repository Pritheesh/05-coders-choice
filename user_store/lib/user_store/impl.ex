defmodule UserStore.Impl do

  @name UserStore.Server

  def register(credentials) do
    GenServer.call(@name, {:register, credentials})
  end

  def login(credentials) do
    GenServer.call(@name, {:login, credentials})
  end

  def display() do
    GenServer.call(@name, :display)
  end

  def get_private_key(credentials) do
    GenServer.call(@name, {:get_private_key, credentials})
  end

  def get_public_key(user) do
    GenServer.call(@name, {:get_public_key, user})
  end

end

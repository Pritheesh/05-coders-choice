defmodule UserStore.Server do

  alias UserStore.Registration
  alias UserStore.Login
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({ :register, credentials }, _from, state) do
    { :reply, Registration.register(credentials), state }
  end

  def handle_call({ :login, credentials }, _from, state) do
    { :reply, Login.login(credentials), state }
  end

  def handle_call(:display, _from, state) do
    { :reply, Registration.display(), state }
  end

  def handle_call({ :get_public_key, username }, _from, state) do
    { :reply, Login.get_public_key(username), state }
  end

  def handle_call({ :get_private_key, credentials }, _from, state) do
    { :reply, Login.get_private_key(credentials), state }
  end

end

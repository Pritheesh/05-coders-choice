defmodule Messenger.Store do

  use GenServer

  def start_link({username, _public, _pid} = tuple) do
    GenServer.start_link(__MODULE__, tuple, name: ref(username))
  end

  ####################

  def handle_call(:get, _from, state) do
    { :reply, state, state }
  end

  defp ref(user) do
    { :global, { :messenger, user } }
  end

end

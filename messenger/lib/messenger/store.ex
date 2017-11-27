defmodule Messenger.Store do

  use GenServer

  def start_link({username, _public} = tuple) do
    GenServer.start_link(__MODULE__, tuple, name: ref(username))
  end

  ####################

  def handle_call(:get_public, _from, state) do
    { :reply, get_public(state), state }
  end

  # prints the received message and replies with message and signature validity
  def handle_info({:message, from_pid, from, to, message, key, signature}, state) do
    IO.puts "#{from} sent #{message}"
    Messenger.Impl.verify(self(), from_pid, from, to, message, key, signature)
    {:noreply, state}
  end

  def handle_info({:check, _to_pid, to, message, :safe}, state) do
    IO.puts "#{to} received #{message}, Result: :safe => Signature valid. Message Integrity achieved."
    {:noreply, state}
  end

  def handle_info({:check, _to_pid, to, message, :danger}, state) do
    IO.puts "#{to} received #{message}, Result: :danger => Invalid Signature. Message Integrity failed."
    {:noreply, state}
  end

  defp get_public(state), do: elem(state, 1)

  defp ref(user), do: {:global, {:messenger, user}}

end

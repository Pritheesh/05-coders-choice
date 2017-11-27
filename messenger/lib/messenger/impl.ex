defmodule Messenger.Impl do

  # Checks the credentials of the user and starts a child process
  def start(credentials) do
    authenticate(credentials)
    |> create
  end

  def send_message({from, password, to, message}) do
    from = String.downcase(from)
    UserStore.login({from, password})
    |> get_pid_and_send(from, password, to, message)
  end

  def verify(to_pid, from_pid, _from, to, message, key, signature) do
    {result, msg} = Ds.verify({message, signature, key})
    send from_pid, {:check, to_pid, to, msg, result}
    :ok
  end

  ##############################

  defp get_pid_and_send(:success, from, password, to, message) do
    {from_pid, to_pid, key} = get_required(from, to)
    {_msg, signature} = Ds.sign {:password, from, password, message}
    send to_pid, {:message, from_pid, from, to, message, key, signature}
    :ok
  end

  defp get_pid_and_send(:failure, _from, _password, _to, _message) do
    raise "Invalid username or password. Please try again."
  end

  defp get_required(from, to) do
    from_pid = :global.whereis_name {:messenger, from}
    to_pid = :global.whereis_name {:messenger, to}
    key = GenServer.call(from_pid, :get_public)
    {from_pid, to_pid, key}
  end

  defp authenticate({username, _password} = cred) do
    UserStore.get_private_key(cred)
    |> get_public(username)
  end

  defp get_public({:ok, _private}, username) do
    {:ok, public} = UserStore.get_public_key(username)
    { public, username }
  end

  defp get_public(error, _username), do: error

  defp create({:error, error}),   do: error
  defp create({public, username}) do
    username = String.downcase(username)
    Supervisor.start_child(Messenger.Supervisor, [{username, public}])
  end

end

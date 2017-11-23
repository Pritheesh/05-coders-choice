defmodule Messenger.Impl do

  def create_process(credentials) do
    authenticate(credentials)
    |> create
  end

  def chat_client() do

    receive do
      { _from, username, message, digest } ->
        IO.inspect Ds.Generator.compare({message, digest}, username)
    end

    chat_client()

  end

  def send_message({from, password, to, message}) do
    {from, pid_from, pid_to} = down_and_pid(from, to)
    { _msg, digest } = Ds.generate_ds {:password, from, password, message}
    send pid_to, { pid_from, from, message, digest }
    :ok
  end

  ##############################

  defp authenticate({username, _password} = cred) do
    UserStore.get_private_key(cred)
    |> get_public(username)
  end

  defp create({:error, error}),   do: error

  defp create({public, username}) do
    pid = spawn_link(__MODULE__, :chat_client, [])
    username = String.downcase(username)
    :global.register_name(String.to_atom(username), pid)
    Supervisor.start_child(Messenger.Supervisor, [{username, public, pid}])
  end

  defp get_public({:ok, _private}, username) do
    {:ok, public} = UserStore.get_public_key(username)
    { public, username }
  end

  defp get_public(error, _username), do: error

  defp get_pid(name) do
    name
    |> String.to_atom
    |> :global.whereis_name
    |> check_undefined
  end

  defp check_undefined(:undefined), do: raise "Invalid username entered"
  defp check_undefined(name),       do: name

  defp down_and_pid(from, to) do
    from = String.downcase from
    to = String.downcase to
    pid_from = get_pid(from)
    pid_to = get_pid(to)
    {from, pid_from, pid_to}
  end

end

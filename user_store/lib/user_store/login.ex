defmodule UserStore.Login do

  use GenServer

  def get_private_key(cred) do
    cred
    |> authenticate
    |> get_key(:private_key)
  end

  def get_public_key(username) do
    username = String.downcase(username)
    find_user(username)
    |> get_key(:public_key)
  end

  def login({ _username, _password } = cred) do
    cred
    |> authenticate
    |> get_key(nil)
  end

  ##################################################

  defp authenticate({ username, password }) do
    username = String.downcase(username)
    password = get_hash(username, password)
    find_user_with_pass(username, password)
  end

  defp get_key(nil, nil),           do: :failure
  defp get_key(_user, nil),         do: :success
  defp get_key(nil, :public_key),   do: { :error, "Invalid username. Please enter correct username." }
  defp get_key(nil, :private_key),  do: { :error, "Invalid credentials. Please try again." }
  defp get_key(user, :private_key), do: { :ok, user.private_key }
  defp get_key(user, :public_key),  do: { :ok, user.public_key }

  defp find_user(username) do
    Agent.get(UserStore.Store, &(Enum.find(&1, fn user ->
      user.username == username
    end)))
  end

  defp find_user_with_pass(username, password) do
    Agent.get(UserStore.Store, &(Enum.find(&1, fn user ->
      user.password == password && user.username == username
    end)))
  end

  defp get_hash(username, pass) do
    { nil, { _username, password } } = UserStore.Registration.hash_password(true, { username, pass })
    password
  end

end

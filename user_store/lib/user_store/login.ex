defmodule UserStore.Login do

  use GenServer

  def get_private_key({username, password}) do
    username = String.downcase(username)
    password = get_hash(username, password)
    find_user_with_pass(username, password)
    |> check_nil(:private_key)
  end

  def get_public_key(username) do
    username = String.downcase(username)
    find_user(username)
    |> check_nil(:public_key)
  end

  defp check_nil(nil, :public_key),   do: "Invalid username. Please enter correct username."
  defp check_nil(nil, :private_key),  do: "Invalid credentials. Please try again."
  defp check_nil(user, :private_key), do: user.private_key
  defp check_nil(user, :public_key),  do: user.public_key

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
    { nil, { _username, password }} = UserStore.Registration.hash_password(true, {username, pass})
    password
  end

end

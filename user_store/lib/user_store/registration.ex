defmodule UserStore.Registration do

  def register(credentials) do
    credentials
    |> validate_username
    |> validate_password_and_hash
    |> generate_keys
    |> put_state
  end

  def display(), do: get_usernames()

  defp put_state({ nil, {username, password}, { public, private }}) do
    Agent.update(UserStore.Store, fn store ->
      [ %UserStore.User
          {
            username:    username,
            password:    password,
            public_key:  public,
            private_key: private
          }
        | store ]
    end)
  end

  defp put_state({error, _credentials}), do: error

  defp generate_keys({ nil, credentials }) do
    public_key  = "public_key.pem"
    private_key = "private_key.pem"

    { _, 0 } = System.cmd "openssl", [ "genrsa", "-out", private_key, "2048" ], [stderr_to_stdout: true]
    { _, 0 } = System.cmd "openssl",
      [ "rsa", "-pubout", "-in", private_key, "-out", public_key ], [stderr_to_stdout: true]

    { nil, credentials, read_files(public_key, private_key) }
  end

  defp generate_keys(error), do: error

  defp read_files(public_key, private_key) do
    { :ok, private } = File.read(private_key)
    { :ok, public } = File.read(public_key)
    File.rm!(private_key)
    File.rm!(public_key)
    { public, private }
  end

  defp get_usernames() do
    Agent.get(UserStore.Store, fn state ->
      Enum.map(state, &(&1.username))
    end)
  end

  defp validate_username({username, password}) do
    username = String.downcase(username)
    error = username
            |> validate_length(3, 100)
            |> check_username(user_exists?(username))
    { error, { username, password } }
  end

  defp user_exists?(username) do
    get_usernames()
    |> Enum.member?(username)
  end

  defp check_username(nil, true), do: "User with given username already exists. Please try again."
  defp check_username(nil, _),    do: nil
  defp check_username(msg, _),    do: msg

  defp validate_length(username, min, max) do
    length = String.length(username)
    nil
    |> too_short(length, min)
    |> too_long(length, max)
  end

  defp too_short(nil, length, min) when length < min, do: "username is too short."
  defp too_short(nil, _, _), do: nil

  defp too_long(nil,length, max) when length > max, do: "username is too long."
  defp too_long(nil, _, _), do: nil
  defp too_long(msg, _, _), do: msg

  defp validate_password_and_hash({ nil, { username, password } }) do
    validate_password(password)
    |> hash_password({ username, password })
  end

  defp validate_password_and_hash({ msg, credentials }) do
    { msg, credentials }
  end

  defp validate_password(password) do
    ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@#!%*?&])[A-Za-z\d$@#!%*?&]{8,}/
    |> Regex.match?(password)
  end

  def hash_password(true, { username, password }) do
    password = username
              |> generate_salt
              |> hash(password)
              |> Base.encode64
    { nil, { username, password } }
  end

  def hash_password(false, { username, password }) do
    error = "Password must contain at least 1 lowercase letter, 1 uppercase letter, 1 special " <>
            "character, 1 number and minimum length of 8"
    { error, { username, password } }
  end

  defp generate_salt(string), do: Base.encode32(string)

  defp hash(salt, password), do: :crypto.hash :sha512, password <> salt

end

defmodule Ds.Generator do

  def generate_ds({username, password, message}) do
    get_priv_key(username, password)
    |> hash_message(message)
    |> encrypt_digest
  end

  defp get_priv_key(username, password) do
    UserStore.get_private_key({username, password})
    |> check_errors
  end

  defp check_errors({:ok, _key} = priv), do: priv
  defp check_errors(error),              do: error

  defp hash_message({:ok, key}, message) do
    {message, :crypto.hash(:sha512, message), key}
  end

  defp hash_message({:error, _err} = error, _message), do: error

  defp encrypt_digest({message, digest, key}) do
    {message, :public_key.encrypt_private(digest, key)}
  end

  defp encrypt_digest(error), do: error

#  defp decrypt_digest({message, digest, key}) do
#    {message, :public_key.decrypt_public(digest, key)}
#  end
#
#  defp decrypt_digest(error), do: error


  # For testing
  def compare({message, encr_digest}, username) do
    {:ok, key} = UserStore.get_public_key(username)
    {_msg, digest, _key1} = {:ok, key} |> hash_message(message)
    decrypted_digest = :public_key.decrypt_public(encr_digest, key)
    digest == decrypted_digest
  end

#  UserStore.register {"pri", "AsdAsd!23"}
#  Ds.Generator.generate_ds {"pri", "AsdAsd!23", "123"}

end
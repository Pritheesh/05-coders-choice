defmodule Ds.Generator do

  # signs the message using the key obtained by username and password
  def sign({ :password, username, password, message }) do
    get_priv_key(username, password)
    |> hash_message(message)
    |> encrypt_digest
  end

  # verifies the signature against the message
  def verify({ message, signature, public_key }) do
#    message = "ok"
    { _msg, digest, _key1 } = { :ok, public_key }
                            |> hash_message(message)
    decrypted_digest = :public_key.decrypt_public(signature, public_key)
    check_correct(message, digest, decrypted_digest)
  end

  ####################################

  defp get_priv_key(username, password) do
    UserStore.get_private_key({ username, password })
    |> check_errors
  end

  defp check_errors({ :ok, _key } = priv), do: priv
  defp check_errors(error),                do: error

  defp hash_message({ :ok, key }, message) do
    { message, :crypto.hash(:sha512, message), key }
  end

  defp hash_message({ :error, _err } = error, _message), do: error

  defp encrypt_digest({ message, digest, key }) do
    { message, :public_key.encrypt_private(digest, key) }
  end

  defp encrypt_digest(error), do: error

  defp check_correct(message, digest, decrypted) when digest == decrypted, do: { :safe, message }
  defp check_correct(message, _digest, _decrypted),                        do: { :danger, message }

end

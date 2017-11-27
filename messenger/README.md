# Messenger

**The Messenger module is to check implementation of the UserStore and Digital Signature
 modules**

## Working

* Go to `05-coders-choice/messenger` and execute the following commands.

* iex -S mix

~~~ elixir

iex>> Messenger.register {"Pri", "AsdAsd!23"}
{:ok, :ok}

iex>> Messenger.register {"Pra", "AsdAsd!23"}
{:ok, :ok}

iex>> Messenger.start {"Pri", "AsdAsd!23"}
{:ok, #PID<0.160.0>}

iex>> Messenger.start {"Pra", "AsdAsd!23"}
{:ok, #PID<0.162.0>}

iex>> Messenger.send_message {"pri", "AsdAsd!23", "pra", "hello"}
pri sent hello
:ok
pra received hello, Result: :safe => Signature valid. Message Integrity achieved.

~~~

* Now uncomment the line where message is assigned a string literal "ok" in the verify function
 and execute again in ds/lib/ds/generator.

```elixir
  def verify({message, signature, public_key}) do
    message = "ok"
    {_msg, digest, _key1} = {:ok, public_key}
                            |> hash_message(message)
    decrypted_digest = :public_key.decrypt_public(signature, public_key)
    check_correct(message, digest, decrypted_digest)
  end
```

* iex -S mix

~~~ elixir

iex>> Messenger.register {"Pri", "AsdAsd!23"}
{:ok, :ok}

iex>> Messenger.register {"Pra", "AsdAsd!23"}
{:ok, :ok}

iex>> Messenger.start {"Pri", "AsdAsd!23"}
{:ok, #PID<0.170.0>}

iex>> Messenger.start {"Pra", "AsdAsd!23"}
{:ok, #PID<0.172.0>}

iex>> Messenger.send_message {"pri", "AsdAsd!23", "pra", "hello"}
pri sent hello
:ok
pra received ok, Result: :danger => Invalid Signature. Message Integrity failed.

~~~

* Observe the changes in the result. The message received by the user "pra" is different from the message sent 
by the user "pri", hence the result shows that the message integrity has failed.

* `:safe` indicates that the decrypted message digest and the generated message digest are same.

* `:danger` indicates that the message has been modified and hence the encrypted message digest
and the generated message digest are not the same.

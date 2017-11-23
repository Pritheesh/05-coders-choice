# Messenger

**The Messenger module is to check implementation of the UserStore and Digital Signature modules**


## Working

* Go to `05-coders-choice/messenger` and execute the following commands.

* iex -S mix
~~~ elixir

iex>> UserStore.register {"Pri", "AsdAsd!23"}
{:ok, :ok}
iex>> UserStore.register {"Pra", "AsdAsd!23"}
{:ok, :ok}
iex>> Messenger.create_process {"Pri", "AsdAsd!23"}
{:ok, #PID<..>}
iex>> Messenger.create_process {"Pra", "AsdAsd!23"}
{:ok, #PID<..>}
iex>> Messenger.send_message {"pri", "AsdAsd!23", "pra", "hello"}
:ok
:safe
iex>> Messenger.send_message {"pri", "AsdAsd!23", "pro", "hello"}
** (RuntimeError) Invalid username entered

~~~

* `:safe` indicates that the decrypted message digest and the generated message digest are same.

* `:danger` indicates that the message has been modified and hence the encrypted message digest
and the generated message digest are not the same.

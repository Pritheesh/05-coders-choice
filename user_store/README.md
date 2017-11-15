# UserStore

**TODO: Add description**


## Working

* Go to `05-coders-choice/user_store` and execute the following commands.
~~~ elixir
iex -S mix

iex> UserStore.register {"username", "Pass!234"}
# :ok

iex> UserStore.display
# ...

iex> UserStore.get_private_key {"username", "Pass!234"}
# ...

iex> UserStore.get_public_key "username"
# ...
  
~~~
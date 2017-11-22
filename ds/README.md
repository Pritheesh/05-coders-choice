# Ds - Digital Signature

**TODO: Add description**


## Working

* Go to `05-coders-choice/ds` and execute the following commands.

* iex -S mix
~~~ elixir

iex> UserStore.register {"username", "Pass!234"}
# :ok

iex> UserStore.display
# ...

iex> UserStore.get_private_key {"username", "Pass!234"}
# ...

iex> UserStore.get_public_key "username"
# ...

iex> Ds.generate_ds {"username", "Pass!234", "hello"}
# ...


  
~~~
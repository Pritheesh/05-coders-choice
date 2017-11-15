# UserStore

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `user_store` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:user_store, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/user_store](https://hexdocs.pm/user_store).

## Working

Go to 05-coders-choice/user_store and execute the following commands.
~~~ elixir
iex -S mix

iex> UserStore.register {"username", "Pass!234"}
# :ok

iex> UserStore.display
# ...

iex> UserStore.get_private_key {"username", "Pass!234}
# ...

iex> UserStore.get_public_key "username"
# ...

  
~~~
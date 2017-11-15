defmodule UserStore.Application do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(UserStore.Store, [], restart: :transient),
      worker(UserStore.Server, [], restart: :transient),
    ]

    opts = [strategy: :one_for_one, name: UserStore.Supervisor]

    { :ok, _pid } = Supervisor.start_link(children, opts)

  end

end

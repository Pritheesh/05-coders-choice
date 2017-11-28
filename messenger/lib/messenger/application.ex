defmodule Messenger.Application do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Messenger.Supervisor, [], restart: :transient),
    ]

    opts = [strategy: :one_for_one]
    { :ok, _pid } = Supervisor.start_link(children, opts)
  end

end

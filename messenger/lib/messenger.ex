defmodule Messenger do

  defdelegate initiate(credentials), to: Messenger.Impl
  defdelegate send_message(tuple),   to: Messenger.Impl

end

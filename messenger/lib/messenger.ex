defmodule Messenger do

  defdelegate start(credentials),     to: Messenger.Impl
  defdelegate send_message(tuple),    to: Messenger.Impl
  defdelegate register(credentials),  to: UserStore
  defdelegate display(),              to: UserStore

end

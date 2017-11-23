defmodule Messenger do

  defdelegate create_process(credentials), to: Messenger.Impl
  defdelegate send_message(tuple),         to: Messenger.Impl

end

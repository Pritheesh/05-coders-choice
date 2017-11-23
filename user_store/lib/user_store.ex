defmodule UserStore do

  defdelegate register(credentials),     to: UserStore.Impl
  defdelegate display(),                 to: UserStore.Impl
  defdelegate get_private_key(cred),     to: UserStore.Impl
  defdelegate get_public_key(cred),      to: UserStore.Impl

end

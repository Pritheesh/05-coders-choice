defmodule Ds do

  defdelegate generate_ds(cred_and_message), to: Ds.Generator

end

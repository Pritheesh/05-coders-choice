defmodule Ds do

  defdelegate sign(cred_and_message), to: Ds.Generator
  defdelegate verify(signature),      to: Ds.Generator

end

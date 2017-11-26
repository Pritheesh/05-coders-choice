defmodule Test do

  def try(path) do
    File.stream!(path, [], 2048)
    |> Enum.reduce(:crypto.hash_init(:sha512), fn(line, acc) ->
      :crypto.hash_update(acc, line)
    end)
    |> :crypto.hash_final
#    |> Base.encode16
  end

  def hash(data, protocol) do
    :crypto.hash(protocol, data)
  end

end

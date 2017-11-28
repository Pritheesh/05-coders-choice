defmodule Messenger.MessengerTest do
  use ExUnit.Case

  test "process created" do
    UserStore.register { "Pri", "AsdAsd!23" }
    assert { :ok, _pid } = Messenger.start { "Pri", "AsdAsd!23" }
  end

  test "process already started" do
    UserStore.register { "Pra", "AsdAsd!23" }
    assert { :ok, _pid } = Messenger.start { "Pra", "AsdAsd!23" }
    assert { :error, { :already_started, _pid } } = Messenger.start { "Pra", "AsdAsd!23" }
  end

  test "global registration of process successful" do
    UserStore.register { "Pro", "AsdAsd!23" }
    assert { :ok, _pid } = Messenger.start { "Pro", "AsdAsd!23" }
    assert is_pid(:global.whereis_name({ :messenger, "pro" })) == true
  end

end

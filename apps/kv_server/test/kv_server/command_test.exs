defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    _ = start_supervised!({KV.Registry, name: context.test})
    %{pid: context.test}
  end

  @tag :distributed
  test "spawns buckets", %{pid: pid} do
    # Create bucket
    assert KVServer.Command.run({:create, "shopping"}, pid) == {:ok, "OK\r\n"}

    # Put key in bucket
    assert KVServer.Command.run({:put, "shopping", "milk", 1}, pid) == {:ok, "OK\r\n"}

    # Get from bucket that exists
    assert KVServer.Command.run({:get, "shopping", "milk"}, pid) == {:ok, "1\r\nOK\r\n"}
  end
end

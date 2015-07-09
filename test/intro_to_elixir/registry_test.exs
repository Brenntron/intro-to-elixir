defmodule ITE.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent

    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    {:ok, sup} = ITE.Bucket.Supervisor.start_link
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = ITE.Registry.start_link(manager, sup)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert ITE.Registry.lookup(registry, "shopping") == :error

    ITE.Registry.create(registry, "shopping")
    assert {:ok, bucket} = ITE.Registry.lookup(registry, "shopping")

    ITE.Bucket.put(bucket, "milk", 1)
    assert ITE.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    ITE.Registry.create(registry, "shopping")
    {:ok, bucket} = ITE.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert ITE.Registry.lookup(registry, "shopping") == :error
  end

  test "sends events on create and crash", %{registry: registry} do
    ITE.Registry.create(registry, "shopping")
    {:ok, bucket} = ITE.Registry.lookup(registry, "shopping")
    assert_receive {:create, "shopping", ^bucket}

    Agent.stop(bucket)
    assert_receive {:exit, "shopping", ^bucket}
  end

  test "removes bucket on crash", %{registry: registry} do
    ITE.Registry.create(registry, "shopping")
    {:ok, bucket} = ITE.Registry.lookup(registry, "shopping")

    Process.exit(bucket, :shutdown)
    assert_receive {:exit, "shopping", ^bucket}
    assert ITE.Registry.lookup(registry, "shopping") == :error
  end
end

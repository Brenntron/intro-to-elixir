defmodule IntroToElixir.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = IntroToElixir.Registry.start_link
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert IntroToElixir.Registry.lookup(registry, "shopping") == :error

    IntroToElixir.Registry.create(registry, "shopping")
    assert {:ok, bucket} = IntroToElixir.Registry.lookup(registry, "shopping")

    IntroToElixir.Bucket.put(bucket, "milk", 1)
    assert IntroToElixir.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    IntroToElixir.Registry.create(registry, "shopping")
    {:ok, bucket} = IntroToElixir.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert IntroToElixir.Registry.lookup(registry, "shopping") == :error
  end
end

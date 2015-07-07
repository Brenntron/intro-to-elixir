defmodule IntroToElixir.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = IntroToElixir.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test 'stores values by key', %{bucket: bucket} do
    assert IntroToElixir.Bucket.get(bucket, 'milk') == nil

    IntroToElixir.Bucket.put(bucket, 'milk', 3)
    assert IntroToElixir.Bucket.get(bucket, 'milk') == 3
  end

  test 'delete the values by key', %{bucket: bucket} do
    assert IntroToElixir.Bucket.get(bucket, 'milk') == nil

    IntroToElixir.Bucket.put(bucket, 'milk', 3)
    assert IntroToElixir.Bucket.get(bucket, 'milk') == 3
    IntroToElixir.Bucket.delete(bucket, 'milk')
    assert IntroToElixir.Bucket.get(bucket, 'milk') == nil
  end
end

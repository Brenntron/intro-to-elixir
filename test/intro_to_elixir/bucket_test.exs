defmodule IntroToElixir.BucketTest do
  use ExUnit.Case, async: true

  test 'stores values by key' do
    {:ok, bucket} = IntroToElixir.Bucket.start_link
    assert IntroToElixir.Bucket.get(bucket, 'milk') == nil

    IntroToElixir.Bucket.put(bucket, 'milk', 3)
    assert IntroToElixir.Bucket.get(bucket, 'milk') == 3
  end
end

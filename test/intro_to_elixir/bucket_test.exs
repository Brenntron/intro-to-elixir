defmodule ITE.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = ITE.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test 'stores values by key', %{bucket: bucket} do
    assert ITE.Bucket.get(bucket, 'milk') == nil

    ITE.Bucket.put(bucket, 'milk', 3)
    assert ITE.Bucket.get(bucket, 'milk') == 3
  end

  test 'delete the values by key', %{bucket: bucket} do
    assert ITE.Bucket.get(bucket, 'milk') == nil

    ITE.Bucket.put(bucket, 'milk', 3)
    assert ITE.Bucket.get(bucket, 'milk') == 3
    ITE.Bucket.delete(bucket, 'milk')
    assert ITE.Bucket.get(bucket, 'milk') == nil
  end
end

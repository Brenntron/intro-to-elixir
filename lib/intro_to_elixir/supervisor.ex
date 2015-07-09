defmodule IntroToElixir.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager_name IntroToElixir.EventManager
  @registry_name IntroToElixir.Registry
  @bucket_sup_name IntroToElixir.Supervisor

  def init(:ok) do
    children = [
      worker(GenEvent, [[name: @manager_name]]),
      supervisor(IntroToElixir.Bucket.Supervisor, [[name: @bucket_sup_name]]),
      worker(IntroToElixir.Registry, [@manager_name, @bucket_sup_name, [name: @registry_name]])
    ]

  supervise(children, strategy: :one_for_one)
  end
end

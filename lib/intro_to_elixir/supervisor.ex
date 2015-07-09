defmodule ITE.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager_name ITE.EventManager
  @registry_name ITE.Registry
  @bucket_sup_name ITE.Supervisor

  def init(:ok) do
    children = [
      worker(GenEvent, [[name: @manager_name]]),
      supervisor(ITE.Bucket.Supervisor, [[name: @bucket_sup_name]]),
      worker(ITE.Registry, [@manager_name, @bucket_sup_name, [name: @registry_name]])
    ]

  supervise(children, strategy: :one_for_one)
  end
end

defmodule ITE do
  use Application

  def start(_type, _args) do
    ITE.Supervisor.start_link
  end
end

defmodule IntroToElixir do
  use Application

  def start(_type, _args) do
    IntroToElixir.Supervisor.start_link
  end
end

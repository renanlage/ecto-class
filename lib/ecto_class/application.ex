defmodule EctoClass.Application do
  @moduledoc """
  Application supervisor declaration.

  See https://hexdocs.pm/elixir/Application.html for
  more information on OTP Applications
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {EctoClass.Repo, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EctoClass.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule RemotePicam.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  
  use Application

  alias Workspace

  def start(_type, _args) do
    # Setup factory defaulte data set in /root (writable partitioin)
    Workspace.setup(:remote_picam)
 
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RemotePicam.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: RemotePicam.Worker.start_link(arg)
        # {RemotePicam.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: RemotePicam.Worker.start_link(arg)
      # {RemotePicam.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: RemotePicam.Worker.start_link(arg)
      # {RemotePicam.Worker, arg},
      {Picam.Camera, []},
      {Plug.Cowboy, scheme: :http, plug: RemotePicam.Console, options: [port: 4000]}
    ]
  end

  def target() do
    Application.get_env(:remote_picam, :target)
  end
  
end

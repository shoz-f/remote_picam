defmodule RemotePicam.Console do
  use Plug.Router
  
  alias Workspace

  @wwwroot {:remote_picam, "priv/wwwroot"}

  plug Plug.Static.IndexHtml, at: "/"
  plug :match
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :dispatch
  plug Plug.Static, at: "/", from: @wwwroot
  plug :resp_404

  get "/captured/image.jpg" do
    conn
      |> put_resp_header("content-type", "image/jpeg")
      |> send_file(200, Workspace.path("image.jpg"))
      |> halt
  end
  
  post "/index.html" do
    Picam.set_size(640, 480)

    with {:ok, file} <- File.open(Workspace.path("image.jpg"), [:write]) do
      IO.binwrite(file, Picam.next_frame)
      File.close(file)
    end

    %{conn | method: "GET"}
  end

  match _ do
    conn
  end
  
  def resp_404(conn, _opts) do
    send_resp(conn, 404, "File Not Found")
  end
end

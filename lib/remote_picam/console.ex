defmodule RemotePicam.Console do
  use Plug.Router

  plug Plug.Static.IndexHtml, at: "/"
  plug Plug.Static, at: "/", from: {:remote_picam, "priv/wwwroot"}
  plug :match
  plug Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: {Poison, :decode!, [[as: %RemotePicam{}]]}
  plug :dispatch

  get "/captured/image.jpg" do
    conn
    |> put_resp_header("content-type", "image/jpeg")
    |> send_file(200, RemotePicam.workspace("image.jpg"))
  end

  post "/cmd/capture" do
    RemotePicam.capture()
    send_resp(conn, 201, "captured")
  end

  get "/cmd/cam_setting" do
    {:ok, json} =
      RemotePicam.load("remote_picam.json")
      |> Poison.encode()

	conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, json)
  end

  post "/cmd/cam_setting" do
    RemotePicam.configure(conn.params)
    send_resp(conn, 201, "OK")
  end

  post "/cmd/save_setting" do
    RemotePicam.save("remote_picam.json", conn.params)
    send_resp(conn, 201, "OK")
  end

  match _ do
    send_resp(conn, 404, conn)
  end
  
  def init(opts) do
    IO.inspect opts
  end
end

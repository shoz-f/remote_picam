defmodule RemotePicam do
  @moduledoc """
  """

  @derive [Poison.Encoder]
  defstruct\
    size:       "VGA",
    sharpness:  0,
    contrast:   0,
    brightness: 50,
    saturation: 0,
    iso:        0,
    vstab:      false,
    ev:         0,
    exposure:   "auto",
    fps:        0.0,
    awb:        "auto",
    imxfx:      "none",
    colfx:      "none",
    metering:   "average",
    rotation:   0,
    hflip:      false,
    vflip:      false,
    roi:        [0,0,1,1],
    shutter:    0

  # define workspace path for application
  @workspace unless Mix.env() == :test, do: "/root/remote_picam", else: "./test/tmp"
  
  @doc """
  Add following funcs to manage app workspace
  - setup()
  - workspace(segment_path)
  - homespace(segment_path)
  """
  use Workspace
  def get_env() do
    [
      from:   "priv/remote_picam",
      to:     @workspace,
      app:    Application.app_dir(:remote_picam),
      policy: :replace
    ]
  end

  @doc """
  Capture image with Picam and save it.
  """
  def capture() do
    path = workspace("image.jpg")

    jpeg = next_frame()
    File.write(path, jpeg)
  end

  @doc """
  Load %RemotePicam{} config data from the file and configure Picam.
  options:
    [:skip]      - skip Picam configulaton, read config file only
    [:roll_back] - roll back config file to last one before loading
  """
  def load(path, options \\ []) do
    path = workspace(path)

    if :roll_back in options, do: roll_back_file(path)

    conf = with {:ok, json} <- File.read(path) do
      Poison.decode!(json, as: %__MODULE__{})
    else
      _ -> %__MODULE__{}
    end

    unless :skip in options, do: configure(conf)

    conf
  end

  @doc """
  Save %RemotePicam{} config data to the file
  """
  def save(path, %__MODULE__{}=conf) do
    path = workspace(path)

    make_backup(path)
    File.write(path, Poison.encode!(conf))
  end

  # Simple backup management. It keeps a last file.
  defp make_backup(path),    do: File.cp(path, path<>"~")
  defp roll_back_file(path), do: File.cp(path<>"~", path)

  @doc """
  Configure Picam with %RemotePicam{}
  """
  def configure(%__MODULE__{}=conf) do
    Map.from_struct(conf)
    |> Enum.each(fn {cmd, args} -> invoke(cmd, args) end)
  end

  defp invoke(cmd, args) do
    apply(__MODULE__, cmd, cond do
      is_list(args)   -> args
      is_binary(args) -> [String.to_atom(args)]
      true            -> [args]
    end)
  end

  @doc """
  Picam function enties.
  """
  defdelegate next_frame(),           to: Picam, as: :next_frame
  def size(mode) do
    [x, y] = case mode do
      :QVGA    -> [320, 240]
      :VGA     -> [640, 480]
      :"720p"  -> [1280, 720]
      :"960p"  -> [1280, 960]
      :"1080p" -> [1920, 1080]
      :"5M"    -> [2592, 1944]
      _        -> [640, 480]
    end
    Picam.set_size(x, y)
  end
  defdelegate sharpness(sharpness),   to: Picam, as: :set_sharpness
  defdelegate contrast(contrast),     to: Picam, as: :set_contrast
  defdelegate brightness(brightness), to: Picam, as: :set_brightness
  defdelegate saturation(saturation), to: Picam, as: :set_saturation
  defdelegate iso(iso),               to: Picam, as: :set_iso
  defdelegate vstab(vstab),           to: Picam, as: :set_vstab
  defdelegate ev(ev),                 to: Picam, as: :set_ev
  defdelegate exposure(mode),         to: Picam, as: :set_exposure_mode
  defdelegate fps(rate),              to: Picam, as: :set_fps
  defdelegate awb(mode),              to: Picam, as: :set_awb_mode
  defdelegate imxfx(effect),          to: Picam, as: :set_img_effect
  def colfx(u,v),   do: Picam.set_col_effect({u, v})
  def colfx(:none), do: Picam.set_col_effect(:none)
  defdelegate metering(mode),         to: Picam, as: :set_metering_mode
  defdelegate rotation(angle),        to: Picam, as: :set_rotation
  defdelegate hflip(hflip),           to: Picam, as: :set_hflip
  defdelegate vflip(vflip),           to: Picam, as: :set_vflip
  def roi(x,y,w,h), do: Picam.set_roi("#{x}:#{y}:#{w}:#{h}")
  defdelegate shutter(speed),         to: Picam, as: :set_shutter_speed
end

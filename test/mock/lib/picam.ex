defmodule Picam do
  def next_frame() do
    n = :rand.uniform(3)
    with {:ok, file} <- File.open(RemotePicam.workspace("img/IMG_#{n}.jpg"))
    do
      jpeg = IO.binread(file, :all)
      File.close(file)
      jpeg
    end
  end

  def set_size(width, height), do: IO.inspect({:ok, :set_size, width, height})

  def set_sharpness(sharpness) when sharpness in -100..100, do: IO.inspect({:ok, :set_sharpness, sharpness})
  def set_sharpness(sharpness), do: IO.inspect({:error, :set_sharpness, sharpness})

  def set_contrast(contrast) when contrast in -100..100, do: IO.inspect({:ok, :set_contrast, contrast})
  def set_contrast(contrast), do: IO.inspect({:error, :set_contrast, contrast})

  def set_brightness(brightness) when brightness in 0..100, do: IO.inspect({:ok, :set_brightness, brightness})
  def set_brightness(brightness), do: IO.inspect({:error, :set_brightness, brightness})

  def set_saturation(saturation) when saturation in -100..100, do: IO.inspect({:ok, :set_saturation, saturation})
  def set_saturation(saturation), do: IO.inspect({:error, :set_saturation, saturation})

  def set_iso(iso) when iso in 0..800, do: IO.inspect({:ok, :set_iso, iso})
  def set_iso(iso), do: IO.inspect({:error, :set_iso, iso})

  def set_vstab(vstab) when is_boolean(vstab), do: IO.inspect({:ok, :set_vstab, vstab})
  def set_vstab(vstab), do: IO.inspect({:error, :set_vstab, vstab})

  def set_ev(ev) when ev in -25..25, do: IO.inspect({:ok, :set_ev, ev})
  def set_ev(ev), do: IO.inspect({:error, :set_ev, ev})

  @exposure_modes [
    :auto,
    :night,
    :nightpreview,
    :backlight,
    :spotlight,
    :sports,
    :snow,
    :beach,
    :verylong,
    :fixedfps,
    :antishake,
    :fireworks
  ]
  def set_exposure_mode(mode) when mode in @exposure_modes, do: IO.inspect({:ok, :set_exposure_mode, mode})
  def set_exposure_mode(mode), do: IO.inspect({:error, :set_exposure_mode, mode})

  def set_fps(rate) when is_float(rate) and rate >= 0.0 and rate <= 90.0, do: IO.inspect({:ok, :set_fps, rate})
  def set_fps(rate), do: IO.inspect({:error, :set_fps, rate})

  @awb_modes [
    :off,
    :auto,
    :sun,
    :cloud,
    :shade,
    :tungsten,
    :fluorescent,
    :incandescent,
    :flash,
    :horizon
  ]
  def set_awb_mode(mode) when mode in @awb_modes, do: IO.inspect({:ok, :set_awb_mode, mode})
  def set_awb_mode(mode), do: IO.inspect({:error, :set_awb_mode, mode})

  @img_effects [
    :none,
    :negative,
    :solarise,
    :sketch,
    :denoise,
    :emboss,
    :oilpaint,
    :hatch,
    :gpen,
    :pastel,
    :watercolour,
    :watercolor,
    :film,
    :blur,
    :saturation,
    :colourswap,
    :colorswap,
    :washedout,
    :posterise,
    :colourpoint,
    :colorpoint,
    :colourbalance,
    :colorbalance,
    :cartoon
  ]
  def set_img_effect(effect) when effect in @img_effects, do: IO.inspect({:ok, :set_img_effect, effect})
  def set_img_effect(effect), do: IO.inspect({:error, :set_img_effect, effect})

  def set_col_effect({u, v}) when u in 0..255 and v in 0..255, do: IO.inspect({:ok, :set_col_effect, {u,v}})
  def set_col_effect(:none),  do: IO.inspect({:ok, :set_col_effect, :none})
  def set_col_effect(effect), do: IO.inspect({:error, :set_col_effect, effect})

  @metering_modes [:average, :spot, :backlit, :matrix]
  def set_metering_mode(mode) when mode in @metering_modes, do: IO.inspect({:ok, :set_metering_mode, mode})
  def set_metering_mode(mode), do: IO.inspect({:error, :set_metering_mode, mode})

  def set_rotation(angle) when angle in [0, 90, 180, 270], do: IO.inspect({:ok, :set_rotation, angle})
  def set_rotation(angle), do: IO.inspect({:error, :set_rotation, angle})

  def set_hflip(mode) when is_boolean(mode), do: IO.inspect({:ok, :set_hflip, mode})
  def set_hflip(mode), do: IO.inspect({:error, :set_hflip, mode})
  
  def set_vflip(mode) when is_boolean(mode), do: IO.inspect({:ok, :set_vflip, mode})
  def set_vflip(mode), do: IO.inspect({:error, :set_vflip, mode})
  
  def set_roi(roi) when is_binary(roi), do: IO.inspect({:ok, :set_roi, roi})
  def set_roi(roi), do: IO.inspect({:error, :set_roi, roi})
  
  def set_shutter_speed(speed) when is_integer(speed) and speed >= 0, do: IO.inspect({:ok, :set_shutter_speed, speed})
  def set_shutter_speed(speed), do: IO.inspect({:error, :set_shutter_speed, speed})
end

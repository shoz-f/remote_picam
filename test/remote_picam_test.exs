defmodule RemotePicamTest do
  use ExUnit.Case
  doctest RemotePicam

  @src_conf "./priv/remote_picam/remote_picam.json"
  @tmp_conf "./tmp/remote_picam.json"
  
  test "load/1 read json-style config file and return %RemodePicam{}" do
    {:ok, conf} = RemotePicam.load(@src_conf, [:skip])
    assert Map.equal?(conf, %RemotePicam{})
  end
  
  test "save/2 write json-style config file from args" do
    File.rm(@tmp_conf)
    assert RemotePicam.save(@tmp_conf, %RemotePicam{}) == :ok
    {:ok, conf} = RemotePicam.load(@tmp_conf, [:skip])
    assert Map.equal?(conf, %RemotePicam{})
    
    assert RemotePicam.save(@tmp_conf, %{"size"=>[320,240]}) == :ok
    {:ok, conf} = RemotePicam.load(@tmp_conf, [:skip])
    assert Map.equal?(conf, %RemotePicam{size: [320,240]})
  end
  
  test "read/1 return %RemotePicam{} from map" do
    map = RemotePicam.read_map(%{"size" => [320,240]})
    assert Map.equal?(map, %RemotePicam{size: [320,240]})
  end
  
  test "config/1 set Picam parameters" do
    RemotePicam.configure(%{size: [320,240]})
  end
  
  test "capture/0 capture image and save it to file" do
    RemotePicam.capture()
  end
end

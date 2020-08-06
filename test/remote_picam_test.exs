defmodule RemotePicamTest do
  use ExUnit.Case
  doctest RemotePicam

  @conf "remote_picam.json"
  @temp "remote_picam.tmp"
  
  test "load/1 read json-style config file and return %RemodePicam{}" do
    conf = RemotePicam.load(@conf, [:skip])
    assert Map.equal?(conf, %RemotePicam{})
  end
  
  test "save/2 write json-style config file from args" do
    File.rm(RemotePicam.workspace(@temp))
    assert RemotePicam.save(@temp, %RemotePicam{}) == :ok
    conf = RemotePicam.load(@temp, [:skip])
    assert Map.equal?(conf, %RemotePicam{})
    
    assert RemotePicam.save(@temp, %RemotePicam{size: "QVGA"}) == :ok
    conf = RemotePicam.load(@temp, [:skip])
    assert Map.equal?(conf, %RemotePicam{size: "QVGA"})
  end
  

  test "config/1 set Picam parameters" do
    RemotePicam.configure(%RemotePicam{size: "1080p"})
  end
  
  test "capture/0 capture image and save it to file" do
    #RemotePicam.capture()
  end
end

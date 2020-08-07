# RemotePicam

Remote still camera example with Nerves/Picam

Nerves/Picamライブラリを用いた Wifiリモート・スチル・カメラの Nervesアプリです。

[注]Picamライブラリは MJPEGビデオ配信を出来る様に設計されていますが、このアプリでは敢えてスチル・カメラとして利用しています。

## Instaration
Nervesの [VintageNet](https://github.com/nerves-networking/vintage_net)ライブラリの Wifiコネクトを使用しています。<br>
接続先の Wifiルーターの SSID/PSKは、環境変数"NERVES_NETWORK_SSID"と"NERVES_NETWORK_PSK"から読み取ります。
アプリをビルドする前に、お使いの Wifiルーターの SSID/PSKを各環境変数にセットして下さい。

```bash
export NERVES_NETWORK_SSID="******"
export NERVES_NETWORK_PSK="******"
```

<br>
このリポジトリにアップしているファイル・セットでは、ターゲット・デバイスを無印ラズパイとラズパイ3に絞った設定になっています。
その他のラズパイで利用する場合は、"./mix.exs"に依存関係を追加して下さい。

```elixir:mix.exs
defmodule RemotePicam.MixProject do
  use Mix.Project
  :
  :
  @all_targtes [:rpi, :rpi3]    <-- ここに :rpi0等を追加
  :
  :
  def deps do
    [
      :
      :
      # Dependencies for specific targets
      {:nerves_system_rpi, "~> 1.12", runtime: false, targets: :rpi},
      <-- ここに {:nerves_system_rpi0, ……}等を追加
    ]
  end
  :
```
<br>
ビルド& SDカード作成は、Nervesアプリの基本のビルト手順の通りです。

```bash
export MIX_TARGET=rpi
mix deps.get
mix firmware
<<SDをカード・スロットに挿入>>
mix burn
```

## Usage
ラズパイへのカメラの接続は、例えば下記のドキュメントを参考にしてください。

* Getting started with the Camera Module:<br>
https://projects.raspberrypi.org/en/projects/getting-started-with-picamera

<br>
上で作成したSDカードをラズパイに差し込み電源を入れると、ラズパイ上で HTTPサーバーが立ち上がります。<br>
PCのブラウザで
<pre>"http://nerves.local:4000"</pre>
を開けば、このアプリのコンソール画面が表示されます。カメラのシャッターは、画面の下の方にある [Capture]ボタンです。
また、画面の上の方にある [Camera setting]を押せば、カメラのモード設定画面が現れます。

![Remote_picam console](/docs/img/remote_picam_console.jpg)

Enjoy (^^)v

## Learn more
* Official docs: https://hexdocs.pm/nerves/getting-started.html
* Picam: https://hexdocs.pm/picam/Picam.html#content
* Picam GitHub: https://github.com/elixir-vision/picam
* VintageNet: https://hexdocs.pm/vintage_net/cookbook.html

defmodule WorkspaceTest do
  use ExUnit.Case
  doctest Workspace
  
  defmodule App do
    use Workspace
    def get_env() do
      [
        from:   "priv/remote_picam",
        to:     "./test/tmp/workspace",
        app:    Application.app_dir(:remote_picam),
        policy: :replace
      ]
    end
  end
  
  @src_dir Keyword.get(App.get_env(), :from)
  @dst_dir Keyword.get(App.get_env(), :to)

  test "home/2 return root of source tree" do
    expect_src_root = Application.app_dir(:remote_picam)
      |> Path.join(@src_dir)

    assert Workspace.home(App) == expect_src_root
    assert Workspace.home(App, "img") == expect_src_root |> Path.join("img")
  end

  test "App.homespace/2 return root of source tree" do
    expect_src_root = Application.app_dir(:remote_picam)
      |> Path.join(@src_dir)

    assert App.homespace() == expect_src_root
    assert App.homespace("img") == expect_src_root |> Path.join("img")
  end

  test "work/2 return root of destination tree" do
    expect_dst_root = @dst_dir

    assert Workspace.work(App) == expect_dst_root
    assert Workspace.work(App,"img") == expect_dst_root |> Path.join("img")
  end
  
  test "App.workspace/1 return root of destination tree" do
    expect_dst_root = @dst_dir

    assert App.workspace() == expect_dst_root
    assert App.workspace("img") == expect_dst_root |> Path.join("img")
  end
  
  test "setup/1 copy Workspace default from priv/src_dir to dst_dir in config" do
    File.rm_rf(@dst_dir)
    assert {:ok, _} = App.setup()
    assert File.exists?(@dst_dir)
  end
end

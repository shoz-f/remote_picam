defmodule WorkspaceTest do
  use ExUnit.Case
  doctest Workspace
  
  alias Workspace
  
  @src_dir "workspace"
  @dst_dir "./tmp/workspace"

  setup_all do
    Application.put_env(:workspace, :from, @src_dir)
    Application.put_env(:workspace, :to,   @dst_dir)
  end
  
  test "org_path/1 return root of source tree" do
    expect_src_root = Application.app_dir(:workspace)
      |> Path.join("priv")
      |> Path.join(@src_dir)

    assert Workspace.org_path(:workspace) == expect_src_root
    assert Workspace.org_path(:workspace, "img") == expect_src_root |> Path.join("img")
  end
  
  test "path/1 return root of destination tree" do
    expect_dst_root = @dst_dir
    
    assert Workspace.path() == expect_dst_root
    assert Workspace.path("img") == expect_dst_root |> Path.join("img")
  end
  
  test "setup/1 copy Workspace default from priv/src_dir to dst_dir in config" do
    File.rm_rf(@dst_dir)
    assert {:ok, _} = Workspace.setup(:workspace)
    assert File.exists?(@dst_dir)
  end
end

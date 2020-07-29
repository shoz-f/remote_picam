defmodule Workspace do

  @src_default ""
  @dst_default "/root"

  def setup(app) do
    File.cp_r(org_path(app), path())
  end

  def org_path(app, segments \\ "") do
    src_dir = Application.get_env(:workspace, :from, @src_default)
    
    Application.app_dir(app, "priv")
      |> Path.join(src_dir)
      |> Path.join(segments)
  end

  def path(segments \\ "") do
    Application.get_env(:workspace, :to, @dst_default)
      |> Path.join(segments)
  end 
end

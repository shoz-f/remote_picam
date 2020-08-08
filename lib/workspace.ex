defmodule Workspace do

  @src_default "priv"
  @dst_default "/root"

  @callback get_env() :: [{atom(), any()}]

  def setup(mod) do
    from   = home(mod)
    to     = work(mod)
    policy = Keyword.get(mod.get_env(), :policy, :replace)

    # mkdir if not exist
    Path.split(to)
    |> Enum.reduce("", fn x, path ->
         path = Path.join(path, x)
         unless File.exists?(path), do: File.mkdir(path)
      	 path
       end)

    File.cp_r(from, to, &cp_policy(policy, &1, &2))
  end
    
  defp cp_policy(:keep, _from, _to), do: false
  defp cp_policy(:update, from, to) do
    with {:ok, %{mtime: time_from}} <- File.stat(from, time: :posix),
         {:ok, %{mtime: time_to  }} <- File.stat(to,   time: :posix)
    do
      time_from > time_to
    else
      _ -> false
  end
  end
  defp cp_policy(_, _from, _to), do: true		# :replace also

  def home(mod, segments \\ "") do
    mod.get_env()
    |> (&[Keyword.get(&1, :app), Keyword.get(&1, :from, @src_default)]).()
    |> Path.join()
    |> Path.join(segments)
  end

  def work(mod, segments \\ "") do
    mod.get_env()
    |> Keyword.get(:to, @dst_default)
    |> Path.join(segments)
  end
  
  defmacro __using__(_opts) do
    quote do
      @behaviour Workspace
      def setup(), do: Workspace.setup(__MODULE__)
      def homespace(segment \\ ""), do: Workspace.home(__MODULE__, segment)
      def workspace(segment \\ ""), do: Workspace.work(__MODULE__, segment)
    end
  end
end

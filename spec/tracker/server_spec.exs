defmodule TrackerServerSpec do
  use ESpec
  alias Tracker.Server

  it "should allocate unused workers to the provided host" do
    {:ok, server} = Server.start_link()

    expect Server.allocate(server, "apibox") |> to(eq "apibox1")
    expect Server.allocate(server, "apibox") |> to(eq "apibox2")
    state = Server.check_state(server)
    expect state["apibox"] |> to(eq [1, 2])
  end

  it "should deallocate workers" do
    {:ok, server} = Server.start_link()

    expect Server.allocate(server, "apibox") |> to(eq "apibox1")
    expect Server.check_state(server) |> Map.get("apibox") |> to(eq [1])
    expect Server.deallocate(server, "apibox1") |> to(eq nil)
    expect Server.check_state(server) |> Map.get("apibox") |> to(eq [])
  end

  it "should reset worker counts for new hosts" do
    {:ok, server} = Server.start_link()

    expect Server.allocate(server, "apibox") |> to(eq "apibox1")
    expect Server.allocate(server, "sitebox") |> to(eq "sitebox1")
    expect Server.check_state(server) |> Map.get("apibox") |> to(eq [1])
    expect Server.check_state(server) |> Map.get("sitebox") |> to(eq [1])
  end

  it "should return nil even if no worker to deallocate" do
    {:ok, server} = Server.start_link()

    expect Server.check_state(server) |> to(eq %{})
    expect Server.deallocate(server, "apibox1") |> to(eq nil)
  end
end
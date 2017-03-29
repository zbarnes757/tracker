defmodule TrackerSpec do
  use ESpec

  it "should return next avaliable worker" do
    expect Tracker.worker_pool([5, 3, 1]) |> to(eq 2)
  end

  it "should return 1 if it is not in the list" do
    expect Tracker.worker_pool([2, 3]) |> to(eq 1)
  end

  it "should return 1 if list is empty" do
    expect Tracker.worker_pool([]) |> to(eq 1)
  end

  it "should return the next number is all workers accounted for" do
    expect Tracker.worker_pool([3, 2, 1]) |> to(eq 4)
  end
end

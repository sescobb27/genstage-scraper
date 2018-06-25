defmodule PlaceScraper.Scraper.Pipeline.PaginationProducer do
  use GenStage
  require Logger

  def start_link(partitions) do
    GenStage.start_link(__MODULE__, partitions, name: __MODULE__)
  end

  def init(partitions) do
    {
      :producer,
      {:queue.new(), 0},
      dispatcher: {GenStage.PartitionDispatcher, partitions: partitions}
    }
  end

  def process_url(adapter, city, url) do
    GenStage.call(__MODULE__, {:enqueue, {adapter, city, url}}, :infinity)
  end

  def handle_call({:enqueue, {adapter, city, url}}, _from, {queue, pending_demand}) do
    new_queue = :queue.in({adapter, city, url}, queue)

    {items, state} =
      apply(adapter, :new, [[url: url]])
      |> PlaceScaper.Scraper.scrape_pagination_url()
      |> Enum.reduce(queue, fn pagination_link, acc ->
        :queue.in({adapter, city, pagination_link}, queue)
      end)
      |> take_links(pending_demand, [])

    {:reply, :ok, items, state}
  end

  def handle_demand(demand, {queue, pending_demand}) do
    total_demand = pending_demand + demand
    {items, state} = take_links(queue, total_demand, [])
    {:noreply, items, state}
  end

  defp take_links(queue, 0, items), do: {items, {queue, 0}}

  defp take_links(queue, n, items) when n > 0 do
    case :queue.out(queue) do
      {:empty, ^queue} -> {items, {queue, n}}
      {{:value, item}, queue} -> take_links(queue, n - 1, [item | items])
    end
  end
end

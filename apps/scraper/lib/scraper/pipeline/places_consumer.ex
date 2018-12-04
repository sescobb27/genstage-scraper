defmodule PlaceScraper.Scraper.Pipeline.PlacesConsumer do
  use GenStage

  require Logger

  @producer PlaceScraper.Scraper.Pipeline.PlacesProducer

  def start_link(partition) do
    name = :"#{__MODULE__}#{partition}"
    GenStage.start_link(__MODULE__, partition, name: name)
  end

  def init(partition) do
    demand = Application.get_env(:twd, :places_demand, 5)

    # REFERENCE:
    # https://elixirforum.com/t/genstage-subscribing-multiple-stages-on-start-up/2053/4
    # https://github.com/wfgilman/stage_test
    producer = :"#{@producer}#{partition}"

    {
      # :producer_consumer,
      :consumer,
      {:queue.new(), 0},
      subscribe_to: [
        {producer, partition: partition, max_demand: demand}
      ]
    }
  end

  def handle_events(events, _from, state) do
    places =
      events
      |> Enum.map(fn {adapter, _city, url} ->
        apply(adapter, :new, [[url: url]])
        |> PlaceScaper.Scraper.scrape_place_url()
      end)

    Logger.info("[PlacesConsumer] #{inspect(places)}")

    {:noreply, [], state}
  end
end

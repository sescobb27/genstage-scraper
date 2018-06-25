defmodule PlaceScraper.Scraper.Pipeline.PlacesProducer do
  use GenStage
  require Logger

  @producer PlaceScraper.Scraper.Pipeline.PaginationProducer

  def start_link(partition) do
    # REFERENCE:
    # https://elixirforum.com/t/genstage-subscribing-multiple-stages-on-start-up/2053/4
    # https://github.com/wfgilman/stage_test
    name = :"#{__MODULE__}#{partition}"
    GenStage.start_link(__MODULE__, partition, name: name)
  end

  def init(partition) do
    demand = Application.get_env(:twd, :pagination_demand, 5)

    {
      :producer_consumer,
      :ok,
      subscribe_to: [
        {@producer, partition: partition, max_demand: demand}
      ]
    }
  end

  def handle_events(events, _from, state) do
    items =
      events
      |> Enum.reduce([], fn {adapter, city, url}, acc ->
        place_urls =
          apply(adapter, :new, [[url: url]])
          |> PlaceScaper.Scraper.scrape_places_from_pagination_url()
          |> Enum.map(fn place_url ->
            {adapter, city, place_url}
          end)

        place_urls ++ acc
      end)

    {:noreply, items, state}
  end
end

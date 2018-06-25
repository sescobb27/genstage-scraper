defmodule PlaceScraper.Scraper.Pipeline.PlaceScraperSupervisor do
  use Supervisor

  @name PlaceScraper.Scraper.Pipeline.PlaceScraperSupervisor

  alias PlaceScraper.Scraper.Pipeline.{PlacesProducer, PlacesConsumer, PaginationProducer}

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: @name)
  end

  def init(_) do
    place_consumers_num = Application.get_env(:twd, :place_consumers_num, 5)
    partitions = 0..(place_consumers_num - 1)

    pagination_producer = worker(PaginationProducer, [partitions])

    places_producer =
      Enum.map(partitions, fn partition ->
        Supervisor.child_spec({PlacesProducer, partition}, id: "place_producer_#{partition}")
      end)

    consumers =
      Enum.map(partitions, fn partition ->
        Supervisor.child_spec({PlacesConsumer, partition}, id: "place_consumer_#{partition}")
      end)

    children = [pagination_producer | places_producer ++ consumers]
    Supervisor.init(children, strategy: :rest_for_one)
  end
end

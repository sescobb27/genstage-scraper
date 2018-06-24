defmodule PlaceScrapper.Scraper.Adapter.TripAdvisor do
  require Logger
  @trip_advisor_url "https://www.tripadvisor.com"
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
  @restaurants_url "#{@trip_advisor_url}/Restaurants"
  @week_days ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  @trip_advisor_tags_map %{
    "restaurant" => ["restaurants in medellin", "dessert in medellin", "bakeries in medellin"],
    "bar" => ["bar", "pub", "bars & pubs in medellin", "brew pub", "bars & pubs in envigado"],
    "cafe" => ["cafe", "café", "coffe", "coffee & tea in medellin", "dessert in medellin"]
  }
end

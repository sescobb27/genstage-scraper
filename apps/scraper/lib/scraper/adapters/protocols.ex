defprotocol PlaceScaper.Scraper do
  def scrape_pagination_url(module)
  def scrape_places_from_pagination_url(module)
  def scrape_place_url(module)
end

defmodule PlaceScraper.Place do
  defstruct [
    :name,
    :location,
    :website_url,
    :address,
    :phone,
    :expense,
    :trip_advisor_rating,
    :google_advisor_rating,
    :yelp_advisor_rating,
    :foursquare_advisor_rating,
    images: [],
    tags: [],
    hours_open: [],
    city: %PlaceScraper.City{},
    categories: []
  ]

  def new(place_attrs \\ []) do
    struct!(__MODULE__, place_attrs)
  end
end

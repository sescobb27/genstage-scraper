defmodule PlaceScrapper.City do
  defstruct [:name, :name_slug, :country, places: []]

  def new(place_attrs \\ []) do
    struct!(__MODULE__, place_attrs)
  end
end

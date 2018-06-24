defmodule PlaceScraper.Category do
  defstruct [:name, places: []]

  def new(place_attrs \\ []) do
    struct!(__MODULE__, place_attrs)
  end
end

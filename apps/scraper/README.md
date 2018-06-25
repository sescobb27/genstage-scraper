# Scraper

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `scraper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scraper, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/scraper](https://hexdocs.pm/scraper).

## Usage
```ex
alias PlaceScraper.Scraper.Pipeline.{PlacesProducer, PaginationProducer}
alias PlaceScraper.Scraper.Adapters.TripAdvisor
alias PlaceScraper.City
:ok = PaginationProducer.process_url(TripAdvisor, %City{name: "medellin"}, "/Restaurants-g297478-Medellin_Antioquia_Department.html")
```

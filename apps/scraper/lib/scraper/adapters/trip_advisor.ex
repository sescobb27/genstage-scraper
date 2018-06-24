defmodule PlaceScraper.Scraper.Adapter.TripAdvisor do
  @moduledoc """
  alias PlaceScraper.Scraper.Adapter.TripAdvisor
  url = "/Restaurants-g297478-Medellin_Antioquia_Department.html"
  {:ok, page} = TripAdvisor.get_page(url)
  restaurant_links = TripAdvisor.get_restaurant_links(page)
  pagination_links = TripAdvisor.generate_pagination_links(url, page)

  {:ok, pampa_page} = TripAdvisor.get_page("/Restaurant_Review-g297478-d5999925-Reviews-La_Pampa_Parrilla_Argentina-Medellin_Antioquia_Department.html")
  TripAdvisor.parse_restaurant_page(pampa_page)
  """

  require Logger

  alias PlaceScraper.{Place, Category}

  @trip_advisor_url "https://www.tripadvisor.com"
  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
  @restaurants_url "#{@trip_advisor_url}/Restaurants"
  @week_days ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  @trip_advisor_tags_map %{
    "restaurant" => ["restaurants in medellin", "dessert in medellin", "bakeries in medellin"],
    "bar" => ["bar", "pub", "bars & pubs in medellin", "brew pub", "bars & pubs in envigado"],
    "cafe" => ["cafe", "café", "coffe", "coffee & tea in medellin", "dessert in medellin"]
  }

  def get_page(link) when is_binary(link) do
    link
    |> build_url()
    |> fetch_page()
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: page}} ->
        {:ok, page}

      {:ok, %HTTPoison.Response{status_code: _} = response} ->
        Logger.error("error fetching link: #{link} response: #{inspect(response)}")
        :error

      {:error, %HTTPoison.Error{reason: :timeout}} ->
        :timeout

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("error fetching link: #{link} reason: #{inspect(reason)}")
        :error
    end
  end

  def get_restaurant_links(page) do
    Floki.find(
      page,
      "#EATERY_LIST_CONTENTS #EATERY_SEARCH_RESULTS .listing.rebrand .shortSellDetails .title a"
    )
    |> Floki.attribute("href")
  end

  def generate_pagination_links(url, page) do
    ranges =
      Floki.find(page, "#EATERY_LIST_CONTENTS .pageNumbers a")
      # ["2", "3", "4", "5", "6", "40"]
      |> Floki.attribute("data-page-number")

    [pag_start | _] = ranges
    pag_last = List.last(ranges)
    {start, _} = Integer.parse(pag_start)
    {last, _} = Integer.parse(pag_last)

    {_, links} =
      Enum.reduce(start..last, {1, []}, fn _pag, {count, acc} ->
        items = count * 30
        formated_url = String.split(url, "-") |> List.insert_at(2, "oa#{items}") |> Enum.join("-")
        {count + 1, [formated_url <> "#EATERY_LIST_CONTENTS" | acc]}
      end)

    links |> Enum.reverse()
  end

  def parse_restaurant_page(page) do
    header = Floki.find(page, "#taplc_location_detail_header_restaurants_0")
    name = Floki.find(header, "#HEADING") |> Floki.text() |> String.trim()

    address = parse_address(header)
    city = parse_city(header)
    country = parse_country(header)
    phone = parse_phone(header)
    tags = parse_tags(header)
    rating = parse_rating(page)
    price_range = parse_price_range(page)
    images = parse_images(page)
    parse_category_tags = parse_category_tags(header)
    hours_open = parse_hours_open(page)

    [lat_str | _] = Regex.run(~r/lat: ([-+]?[0-9]*\.?[0-9]+)/, page, capture: :all_but_first)
    [lon_str | _] = Regex.run(~r/lng: ([-+]?[0-9]*\.?[0-9]+)/, page, capture: :all_but_first)
    {lat, _} = Float.parse(lat_str)
    {lon, _} = Float.parse(lon_str)

    Place.new(
      name: name,
      address: "#{address}, #{city} #{country}",
      phone: phone,
      trip_advisor_rating: rating,
      expense: price_range,
      images: images,
      location: %Geo.Point{coordinates: {lon, lat}, srid: 4326},
      hours_open: hours_open,
      tags: tags,
      categories: Enum.concat(tags, parse_category_tags) |> map_tags()
    )
  end

  defp parse_hours_open(page) do
    case Floki.find(page, "#RESTAURANT_DETAILS .hours.content .detail") do
      [] ->
        nil

      hours_open_table ->
        parse_open_hours(hours_open_table)
    end
  end

  defp fetch_page(link) do
    HTTPoison.get(
      link,
      [
        {"User-Agent", @user_agent},
        {"Origin", @trip_advisor_url},
        {"Referer", @restaurants_url}
      ],
      hackney: [pool: :trip_advisor]
    )
  end

  defp build_url(@trip_advisor_url <> link), do: @trip_advisor_url <> link
  defp build_url(link), do: @trip_advisor_url <> link

  defp parse_open_hours(page) do
    days =
      Floki.find(page, ".day")
      |> Enum.map(fn {_name, _attr, rest} ->
        day_name = Floki.text(rest)
        Enum.find_index(@week_days, &(&1 == day_name))
      end)

    hours_range =
      Floki.find(page, ".hours")
      |> Enum.map(fn {_name, _attr, rest} ->
        Floki.text(rest, sep: "$") |> String.split("$")
      end)

    Enum.zip([days, hours_range])
    |> Enum.sort_by(fn {day, _} -> day end)
    |> Enum.reduce(%{}, fn {day, hours}, acc ->
      schedules = map_hours(hours)
      Map.put(acc, day, schedules)
    end)
  end

  defp parse_address(header) do
    Floki.find(header, ".prw_common_atf_header_bl .address .street-address")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_city(header) do
    Floki.find(header, ".prw_common_atf_header_bl .address .locality")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_country(header) do
    Floki.find(header, ".prw_common_atf_header_bl .address .country-name")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_phone(header) do
    Floki.find(header, ".phone.directContactInfo")
    |> Floki.filter_out(".ui_icon.phone")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_tags(header) do
    Floki.find(header, ".header_links a, .header_links .header_link")
    |> Enum.map(fn {_name, _attr, rest} ->
      Floki.text(rest)
      |> String.downcase()
    end)
  end

  defp parse_rating(page) do
    Floki.find(page, ".rating .overallRating")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_price_range(page) do
    Floki.find(page, "#taplc_restaurants_detail_info_content_0 .price .text")
    |> Floki.text()
    |> String.trim()
  end

  defp parse_images(page) do
    Floki.find(page, ".imageThumbnail .imgWrap noscript img")
    |> Floki.attribute("src")
  end

  defp parse_category_tags(header) do
    Floki.find(header, ".header_popularity.popIndexValidation a")
    |> Enum.map(fn {_name, _attr, rest} ->
      Floki.text(rest)
      |> String.downcase()
    end)
  end

  # input format:
  # ["12:00 PM - 3:00 PM", "6:00 PM - 10:00 PM"],
  # ["12:00 PM - 10:30 PM"],
  defp map_hours(hours) do
    Enum.map(hours, fn range ->
      [open | [close]] =
        range
        |> String.replace(~r/\s+/, "")
        |> String.downcase()
        |> String.split("-")

      %{open: open, close: close, military: false}
    end)
  end

  defp map_tags(tags) do
    Map.keys(@trip_advisor_tags_map)
    |> Enum.reduce(MapSet.new(), fn key, acc ->
      trip_advisor_tags = @trip_advisor_tags_map[key]

      has_tag =
        Enum.any?(tags, fn tag ->
          Enum.member?(trip_advisor_tags, tag)
        end)

      if has_tag do
        MapSet.put(acc, Category.new(name: key))
      else
        acc
      end
    end)
    |> MapSet.to_list()
    |> case do
      [] -> ["restaurant"]
      tags -> tags
    end
  end
end

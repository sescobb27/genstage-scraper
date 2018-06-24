defmodule PlaceScraper.Scraper.Adapter.TripAdvisorTest do
  use ExUnit.Case, async: true
  alias PlaceScraper.Scraper.Adapter.TripAdvisor
  alias PlaceScraper.{Place, Category}

  describe "main page" do
    test "generates all the pagination links from the main city page - Medellin" do
      {:ok, cwd} = File.cwd()

      fixture_file =
        Path.join([cwd, "test", "fixtures", "trip_advisor", "medellin.html"])
        |> File.read!()

      expected_links = [
        "/Restaurants-g297478-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa30-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa60-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa90-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa120-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa150-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa180-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa210-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa240-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa270-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa300-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa330-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa360-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa390-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa420-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa450-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa480-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa510-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa540-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa570-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa600-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa630-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa660-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa690-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa720-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa750-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa780-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa810-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa840-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa870-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa900-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa930-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa960-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa990-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1020-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1050-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1080-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1110-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1140-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g297478-oa1170-Medellin_Antioquia_Department.html#EATERY_LIST_CONTENTS"
      ]

      links =
        TripAdvisor.generate_pagination_links(
          "/Restaurants-g297478-Medellin_Antioquia_Department.html",
          fixture_file
        )

      assert links == expected_links
    end

    test "it generates all the pagination links from the main city page - Bogota" do
      expected_links = [
        "/Restaurants-g294074-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa30-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa60-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa90-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa120-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa150-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa180-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa210-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa240-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa270-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa300-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa330-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa360-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa390-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa420-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa450-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa480-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa510-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa540-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa570-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa600-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa630-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa660-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa690-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa720-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa750-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa780-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa810-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa840-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa870-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa900-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa930-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa960-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa990-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1020-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1050-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1080-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1110-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1140-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1170-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1200-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1230-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1260-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1290-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1320-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1350-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1380-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1410-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1440-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1470-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1500-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1530-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1560-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1590-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1620-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1650-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1680-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1710-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1740-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1770-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1800-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1830-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1860-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1890-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1920-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1950-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa1980-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2010-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2040-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2070-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2100-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2130-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2160-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2190-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2220-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2250-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2280-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2310-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2340-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2370-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2400-Bogota.html#EATERY_LIST_CONTENTS",
        "/Restaurants-g294074-oa2430-Bogota.html#EATERY_LIST_CONTENTS"
      ]

      {:ok, cwd} = File.cwd()

      file =
        Path.join([cwd, "test", "fixtures", "trip_advisor", "bogota.html"])
        |> File.read!()

      links = TripAdvisor.generate_pagination_links("/Restaurants-g294074-Bogota.html", file)
      assert links == expected_links
    end
  end

  describe "review page" do
    test "parse a review page and get it's data" do
      {:ok, cwd} = File.cwd()

      place =
        Path.join([cwd, "test", "fixtures", "trip_advisor", "pampa_argentina.html"])
        |> File.read!()
        |> TripAdvisor.parse_restaurant_page()

      assert %Place{} = place
      assert place.expense == "$$ - $$$"
      assert place.address == "Carrera 33 # 8 a 11, Medellin, Colombia"
      assert place.location == %Geo.Point{coordinates: {-75.56473, 6.207669}, srid: 4326}
      assert place.name == "La Pampa Parrilla Argentina"
      assert place.phone == "+57 4 3115993"
      assert place.trip_advisor_rating == "4.5"
      assert place.tags == ["latin", "gluten free options"]
      assert place.categories == [%PlaceScraper.Category{name: "restaurant", places: []}]

      assert place.hours_open == %{
               0 => [
                 %{close: "3:00pm", open: "12:00pm", military: false},
                 %{close: "10:00pm", open: "6:00pm", military: false}
               ],
               1 => [
                 %{close: "3:00pm", open: "12:00pm", military: false},
                 %{close: "10:00pm", open: "6:00pm", military: false}
               ],
               2 => [
                 %{close: "3:00pm", open: "12:00pm", military: false},
                 %{close: "10:00pm", open: "6:00pm", military: false}
               ],
               3 => [
                 %{close: "3:00pm", open: "12:00pm", military: false},
                 %{close: "10:00pm", open: "6:00pm", military: false}
               ],
               4 => [
                 %{close: "3:00pm", open: "12:00pm", military: false},
                 %{close: "10:30pm", open: "6:00pm", military: false}
               ],
               5 => [
                 %{close: "10:30pm", open: "12:00pm", military: false}
               ],
               6 => [
                 %{close: "5:00pm", open: "12:00pm", military: false}
               ]
             }

      assert place.images == [
               "https://media-cdn.tripadvisor.com/media/photo-s/11/c4/64/44/photo1jpg.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-s/11/c4/64/43/photo0jpg.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-s/11/ba/66/a9/delicioso-monumental.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-s/11/ba/56/57/photo1jpg.jpg"
             ]
    end

    test "parse a review page without open hours and get it's data" do
      {:ok, cwd} = File.cwd()

      place =
        Path.join([cwd, "test", "fixtures", "trip_advisor", "casa_molina.html"])
        |> File.read!()
        |> TripAdvisor.parse_restaurant_page()

      assert %Place{} = place
      assert place.address == "Indiana Mall - Alto de las Palmas, Medellin, Colombia"
      assert place.expense == "$$ - $$$"
      assert place.hours_open == nil

      assert place.images == [
               "https://media-cdn.tripadvisor.com/media/photo-s/08/0b/43/f3/crocante-de-camarones.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-s/10/f6/88/59/photo2jpg.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-o/10/f6/88/58/photo1jpg.jpg",
               "https://media-cdn.tripadvisor.com/media/photo-p/10/f6/88/57/photo0jpg.jpg"
             ]

      assert place.location == %Geo.Point{coordinates: {-75.53259, 6.154403}, srid: 4326}
      assert place.name == "Casa Molina"
      assert place.phone == "3861548"
      assert place.trip_advisor_rating == "4.5"
      assert place.tags == []
      assert place.categories == [%Category{name: "restaurant", places: []}]
    end
  end
end

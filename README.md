# My Umbrella: Do I need an umbrella today?

![My Umbrella](./assets/umbrella.webp)

An example application for the presentation:

Beyond Mocks - Messing with Our Preconceptions of Testing

This application demonstrates various tactics for testing external, unstable dependencies, AKA
infrastructure. For the presentation, the focus is specifically on James Shore's technique,
_Nullables_ from the pattern language _Testing Without Mocks_.

## Example

```elixir
orlando = MyUmbrella.Coordinates.new(28.5383, -81.3792)
MyUmbrella.for_today(orlando)
#=> {:ok, "Thunderstorms! Take two umbrellas!"}
```

## Sequence Diagram

```mermaid
sequenceDiagram
    Controller->>MyUmbrella: for_today(Coordinates.t())
    MyUmbrella->>WeatherApi: get_forecast(Coordinates.t(), :today)
    WeatherApi-->>MyUmbrella: {:ok, list(WeatherReport.t())}
    MyUmbrella->>WeatherReport: filter(list(WeatherReport.t()), :today)
    Weather-->>MyUmbrella: list(WeatherReport.t())
    MyUmbrella->>WeatherReport: determine_most_intense_precipitation_condition(list(WeatherReport.t()), :today)
    WeatherReport-->>MyUmbrella: WeatherReport.t()
    MyUmbrella->>Announcement: from_weather_report(WeatherReport.t())
    Announcement-->>MyUmbrella: Annoucement.t() :: String.t()
    MyUmbrella-->>Controller: {:ok, Annoucement.t() :: String.t()}
```

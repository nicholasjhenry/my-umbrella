import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

if config_env() == :test do
  config :my_umbrella, :weather_api_module, MyUmbrella.WeatherApi.Mock
  config :my_umbrella, :open_weather_map, app_id: "OPEN_WEATHER_MAP_APP_ID_FAKE"
end

import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

if config_env() == :test do
  config :my_umbrella, :weather_api_module, MyUmbrella.WeatherApi.Fake
end

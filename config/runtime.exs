import Config

if config_env() in [:dev, :prod] do
  config :my_umbrella, :open_weather_map, app_id: System.fetch_env!("OPEN_WEATHER_MAP_APP_ID")
end

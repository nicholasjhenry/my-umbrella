defmodule MyUmbrella.Controls.Weather do
  @moduledoc false

  alias MyUmbrella.Weather

  alias MyUmbrella.Controls.Calendar.CurrentDateTime.LocalTime

  def attributes(date_time \\ nil) do
    %{
      date_time: date_time || LocalTime.example(:london),
      code: 800,
      condition: :clear
    }
  end

  def example(date_time \\ nil) do
    Weather.new(attributes(date_time))
  end

  defmodule Cloud do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        condition: :clouds,
        code: 801
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end

  defmodule Drizzle do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        code: 300,
        condition: :drizzle
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end

  defmodule Rain do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        code: 501,
        condition: :rain
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end

  defmodule Snow do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        code: 600,
        condition: :snow
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end

  defmodule Thunderstorm do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        code: 200,
        condition: :thunderstorm
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end

  defmodule Clear do
    @moduledoc false

    def attributes(date_time \\ nil) do
      %{
        date_time: date_time || LocalTime.example(:london),
        code: 800,
        condition: :clear
      }
    end

    def example(date_time \\ nil) do
      Weather.new(attributes(date_time))
    end
  end
end

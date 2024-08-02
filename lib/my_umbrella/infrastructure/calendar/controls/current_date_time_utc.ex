defmodule MyUmbrella.Infrastructure.Calendar.Controls.DateTime do
  @moduledoc false

  @spec before_midnight(DateTime.t()) :: DateTime.t()
  def before_midnight(date_time) do
    DateTime.shift(date_time, minute: 30)
  end

  @spec after_midnight(DateTime.t()) :: DateTime.t()
  def after_midnight(date_time) do
    DateTime.shift(date_time, hour: 4)
  end

  defmodule Utc do
    @moduledoc false

    @spec example(:london | :orlando) :: DateTime.t()
    def example(:london) do
      DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
    end

    def example(:orlando) do
      DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")
      |> DateTime.shift_zone!("Etc/UTC")
    end
  end

  defmodule LocalTime do
    @moduledoc false

    @spec example(:london | :orlando) :: DateTime.t()
    def example(:london) do
      DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
    end

    def example(:orlando) do
      DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")
    end
  end
end

defmodule Parsex.Subtitle.Line do
  defstruct(number: nil, start_time: nil, end_time: nil, text: [])
  @type t :: %Parsex.Subtitle.Line{number: Integer.t, start_time: Float.t,
                                  end_time: Float.t, text: List.t}

  def parse_lines(file_stream) do
    Enum.chunk_by(file_stream, fn(line) -> line != "\n" end)
    |> Enum.filter(fn(elem) -> elem != ["\n"] end)
    |> Enum.map(fn(line) -> parse_line(line) end)
    |> Enum.drop_while(fn(line) -> is_nil(line) end)
  end

  def lines_to_string(lines) do
    Enum.map(lines, fn(line)->
      "#{line.number}\n" <>
      "#{Parsex.Subtitle.Line.seconds_to_timestamp(line.start_time)} --> " <>
      "#{Parsex.Subtitle.Line.seconds_to_timestamp(line.end_time)}\n" <>
      "#{Enum.join(line.text, "\n")}\n"
    end) |> Enum.join("\n")
  end

  def timestamp_to_seconds(time) do
    [_, h, m, s, ms] = Regex.run(~r/(?<h>\d+):(?<m>\d+):(?<s>\d+)[,.](?<ms>\d+)/, time)
    (String.to_integer(h) * 3600)
    |> +((String.to_integer(m)) * 60)
    |> +(String.to_float("#{s}.#{ms}"))
  end

  def seconds_to_timestamp(seconds) do
    [sec_int, decimal] = Float.to_string(seconds, [decimals: 3])
    |> String.split(".")
    |> Enum.map(fn(elem) -> String.to_integer(elem) end)
    h = round(Float.floor(seconds / 3600)) |> append_zero()
    m = round(Float.floor(rem(sec_int, 3600) / 60)) |> append_zero()
    s = rem(sec_int , 60) |> append_zero()
    ms = decimal |> append_zero(:ms)

    "#{h}:#{m}:#{s},#{ms}"
  end

  defp unescape_line(line) do
    Enum.map(line, fn(text) ->
      String.replace(text, ~r/\n|\t|\r/, "")
    end)
  end

  defp format_timestamp(timestamp) do
    timestamp = String.split(timestamp, " --> ")
    start_time = List.first(timestamp) |> timestamp_to_seconds
    end_time = List.last(timestamp) |> timestamp_to_seconds
    %{start_time: start_time, end_time: end_time}
  end

  defp append_zero(number, type \\ :normal) do
    case type do
      :ms ->
        String.rjust(to_string(number), 3, ?0)
      _ ->
        String.rjust(to_string(number), 2, ?0)
    end
  end

  defp parse_line(line) do
    line = unescape_line(line)
    try do
        line_number = Enum.at(line, 0) |> String.to_integer()
        timestamp = Enum.at(line, 1) |> format_timestamp
        texts = Enum.drop(line, 2)

        %Parsex.Subtitle.Line{
          number: line_number,
          start_time: timestamp.start_time,
          end_time: timestamp.end_time,
          text: texts
        }
    rescue
      _ -> nil
    end
  end

  defp sync_line(subtitle, line, sync_time) do

  end

  defp syc_all(subtitle, sync_time) do

  end

  def parse_sync_time(sync_time) do
    instances = %{"ms" => 0.001, "s" => 1, "m" => 60, "h" => 3600}

    case String.match?(sync_time, ~r/([+-])([.,0-9]+)(ms|s|m|h)/) do
      nil -> nil
      _ ->
        try do
          [_, operator, time, time_instance] = Regex.run(~r/([+-])([.,0-9]+)(ms|s|m|h)/, sync_time)
          time_to_add = elem(Float.parse(time), 0) * instances[time_instance]
          {operator, time_to_add}
        rescue
          _ -> nil
        end
    end
  end
end

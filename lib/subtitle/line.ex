defmodule Parsex.Subtitle.Line do
  defstruct(number: nil, start_time: nil, end_time: nil, text: [])
  @type t :: %Parsex.Subtitle.Line{number: Integer.t, start_time: Float.t,
                                  end_time: Float.t, text: List.t}


  def parse_lines(file_stream) do
    Enum.chunk_by(file_stream, fn(line) -> line != "\n" end)
    |> Enum.filter(fn(elem) -> elem != ["\n"] end)
    |> Enum.map(fn(line) -> Parsex.Subtitle.Line.parse_line(line) end)
  end

  def unescape_line(line) do
    Enum.map(line, fn(text) ->
      String.replace(text, ~r/\n|\t|\r/, "")
    end)
  end

  def format_timestamp(timestamp) do
    timestamp = String.split(timestamp, " --> ")
    start_time = List.first(timestamp) |> timestamp_to_seconds
    end_time = List.last(timestamp) |> timestamp_to_seconds
    %{start_time: start_time, end_time: end_time}
  end

  defp timestamp_to_seconds(time) do
    [_, h, m, s, ms] = Regex.run(~r/(?<h>\d+):(?<m>\d+):(?<s>\d+)[,.](?<ms>\d+)/, time)
    (String.to_integer(h) * 3600)
    |> +((String.to_integer(m)) * 60)
    |> +(String.to_float("#{s}.#{ms}"))
  end

  defp seconds_to_timestamp(seconds) do
    
  end

  def parse_line(line) do
    line = unescape_line(line)
    cond do
      Enum.at(line, 0) == " " -> nil
      Enum.at(line, 0) == "" -> nil
      true ->
        line_number = Enum.at(line, 0) |> String.to_integer()
        timestamp = Enum.at(line, 1) |> format_timestamp
        texts = Enum.drop(line, 2)

        %Parsex.Subtitle.Line{
          number: line_number,
          start_time: timestamp.start_time,
          end_time: timestamp.end_time,
          text: texts
        }
    end
  end
end

defmodule Parsex.Subtitle do
  defstruct(filename: nil, framerate: nil, lines: [])
  @type t :: %Parsex.Subtitle{filename: String.t, framerate: Float.t, lines: List.t}

  alias Parsex.Subtitle.Line

  def parse_file(filename) do
    try do
      stream = File.stream!(filename, [:read, :utf8], :line)
      filename = String.split(to_string(filename), "/") |> List.last()
      lines = Line.parse_lines(stream)

      {:ok, %Parsex.Subtitle{filename: filename, lines: lines}}
    rescue
      UndefinedFunctionError -> {:error, :invalid_encoding}
      _ -> {:error}
    end
  end

  def parse_struct(subtitle) do
    filename = subtitle.filename
    content = Line.lines_to_string(subtitle.lines)
    File.write(filename, content, [:write])
  end

  def sync_subtitle(subtitle \\ nil, sync_time \\ "+0ms")
  def sync_subtitle(subtitle = %Parsex.Subtitle{}, sync_time) do
    synced_lines = Line.sync_all_lines(subtitle.lines, sync_time)
    Map.put(subtitle, :lines, synced_lines)
  end
  def sync_subtitle(subtitle, sync_time) do
    {status, subtitle} = parse_file(subtitle)
    case status do
      :ok ->
        synced_lines = Line.sync_all_lines(subtitle.lines, sync_time)
        Map.put(subtitle, :lines, synced_lines)
        |> parse_struct
      _ -> :error
    end
  end
end

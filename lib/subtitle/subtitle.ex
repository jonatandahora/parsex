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
end

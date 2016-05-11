defmodule Parsex.Subtitle do
  defstruct(filename: nil, framerate: nil, lines: [])
  @type t :: %Parsex.Subtitle{filename: String.t, framerate: Float.t, lines: List.t}

  alias Parsex.Subtitle.Line

  def parse_file(filename) do
    stream = File.stream!(filename, [:read, :utf8], :line)

    lines = Line.parse_lines(stream)

    %Parsex.Subtitle{filename: filename, lines: lines}
  end
end

defmodule Parsex.Subtitle do
  defstruct(filename: nil, framerate: nil, lines: [])
  @type t :: %Parsex.Subtitle{filename: String.t, framerate: Float.t, lines: List.t}
end

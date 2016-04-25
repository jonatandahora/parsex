defmodule Parsex.Subtitle.Line do
  defstruct(number: nil, start_time: nil, end_time: nil, text: [])
  @type t :: %Parsex.Subtitle.Line{number: Integer.t, start_time: Float.t,
                                  end_time: Float.t, text: List.t}
end

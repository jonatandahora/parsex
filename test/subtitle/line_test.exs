defmodule Parsex.Subtitle.LineTest do
  use ExUnit.Case

  test "timestamp conversion" do
    timestamp = "00:42:23,025"
    invalid_timestamp = "00:42:23,026"
    seconds = 2543.025
    timestamp_in_seconds = Parsex.Subtitle.Line.timestamp_to_seconds(timestamp)
    seconds_in_timestamp = Parsex.Subtitle.Line.seconds_to_timestamp(seconds)
    invalid_seconds_in_timestamp = Parsex.Subtitle.Line.seconds_to_timestamp(seconds - 10)
    invalid_timestamp_in_seconds = Parsex.Subtitle.Line.timestamp_to_seconds(invalid_timestamp)
    assert timestamp == seconds_in_timestamp
    assert seconds == timestamp_in_seconds
    assert timestamp != invalid_seconds_in_timestamp
    assert seconds != invalid_timestamp_in_seconds
  end

  test "resync time conversion" do
    resync_time = "+10s"
    
  end
end

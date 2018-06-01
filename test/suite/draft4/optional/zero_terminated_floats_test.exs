defmodule Draft4.Optional.ZeroTerminatedFloatsTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "some languages do not distinguish between different types of numeric value" do
    setup do
      %{schema: JsonXema.new(~s( {"type":"integer"} ))}
    end

    test "a float is not an integer even without fractional part", %{
      schema: schema
    } do
      data = 1.0
      refute is_valid?(schema, data)
    end
  end
end
defmodule Draft7.MinLengthTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "minLength validation" do
    setup do
      %{schema: ~s(
        {
          "minLength": 2
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "longer is valid", %{schema: schema} do
      data = "foo"
      assert valid?(schema, data)
    end

    test "exact length is valid", %{schema: schema} do
      data = "fo"
      assert valid?(schema, data)
    end

    test "too short is invalid", %{schema: schema} do
      data = "f"
      refute valid?(schema, data)
    end

    test "ignores non-strings", %{schema: schema} do
      data = 1
      assert valid?(schema, data)
    end

    test "one supplementary Unicode code point is not long enough", %{
      schema: schema
    } do
      data = "💩"
      refute valid?(schema, data)
    end
  end
end

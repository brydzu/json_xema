defmodule Draft6.MaxLengthTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "maxLength validation" do
    setup do
      %{schema: ~s(
        {
          "maxLength": 2
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "shorter is valid", %{schema: schema} do
      data = "f"
      assert valid?(schema, data)
    end

    test "exact length is valid", %{schema: schema} do
      data = "fo"
      assert valid?(schema, data)
    end

    test "too long is invalid", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "ignores non-strings", %{schema: schema} do
      data = 100
      assert valid?(schema, data)
    end

    test "two supplementary Unicode code points is long enough", %{
      schema: schema
    } do
      data = "💩💩"
      assert valid?(schema, data)
    end
  end
end

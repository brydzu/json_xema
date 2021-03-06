defmodule Draft4.MinItemsTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "minItems validation" do
    setup do
      %{schema: ~s(
        {
          "minItems": 1
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "longer is valid", %{schema: schema} do
      data = [1, 2]
      assert valid?(schema, data)
    end

    test "exact length is valid", %{schema: schema} do
      data = [1]
      assert valid?(schema, data)
    end

    test "too short is invalid", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "ignores non-arrays", %{schema: schema} do
      data = ""
      assert valid?(schema, data)
    end
  end
end

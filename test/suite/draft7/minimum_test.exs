defmodule Draft7.MinimumTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "minimum validation" do
    setup do
      %{schema: ~s(
        {
          "minimum": 1.1
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "above the minimum is valid", %{schema: schema} do
      data = 2.6
      assert valid?(schema, data)
    end

    test "boundary point is valid", %{schema: schema} do
      data = 1.1
      assert valid?(schema, data)
    end

    test "below the minimum is invalid", %{schema: schema} do
      data = 0.6
      refute valid?(schema, data)
    end

    test "ignores non-numbers", %{schema: schema} do
      data = "x"
      assert valid?(schema, data)
    end
  end
end

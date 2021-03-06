defmodule Draft6.MaximumTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "maximum validation" do
    setup do
      %{schema: ~s(
        {
          "maximum": 3.0
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "below the maximum is valid", %{schema: schema} do
      data = 2.6
      assert valid?(schema, data)
    end

    test "boundary point is valid", %{schema: schema} do
      data = 3.0
      assert valid?(schema, data)
    end

    test "above the maximum is invalid", %{schema: schema} do
      data = 3.5
      refute valid?(schema, data)
    end

    test "ignores non-numbers", %{schema: schema} do
      data = "x"
      assert valid?(schema, data)
    end
  end
end

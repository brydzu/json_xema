defmodule Draft6.ConstTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "const validation" do
    setup do
      %{schema: ~s(
        {
          "const": 2
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "same value is valid", %{schema: schema} do
      data = 2
      assert valid?(schema, data)
    end

    test "another value is invalid", %{schema: schema} do
      data = 5
      refute valid?(schema, data)
    end

    test "another type is invalid", %{schema: schema} do
      data = "a"
      refute valid?(schema, data)
    end
  end

  describe "const with object" do
    setup do
      %{schema: ~s(
        {
          "const": {
            "baz": "bax",
            "foo": "bar"
          }
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "same object is valid", %{schema: schema} do
      data = %{"baz" => "bax", "foo" => "bar"}
      assert valid?(schema, data)
    end

    test "same object with different property order is valid", %{schema: schema} do
      data = %{"baz" => "bax", "foo" => "bar"}
      assert valid?(schema, data)
    end

    test "another object is invalid", %{schema: schema} do
      data = %{"foo" => "bar"}
      refute valid?(schema, data)
    end

    test "another type is invalid", %{schema: schema} do
      data = [1, 2]
      refute valid?(schema, data)
    end
  end

  describe "const with array" do
    setup do
      %{schema: ~s(
        {
          "const": [
            {
              "foo": "bar"
            }
          ]
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "same array is valid", %{schema: schema} do
      data = [%{"foo" => "bar"}]
      assert valid?(schema, data)
    end

    test "another array item is invalid", %{schema: schema} do
      data = [2]
      refute valid?(schema, data)
    end

    test "array with additional items is invalid", %{schema: schema} do
      data = [1, 2, 3]
      refute valid?(schema, data)
    end
  end

  describe "const with null" do
    setup do
      %{schema: ~s(
        {
          "const": null
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "null is valid", %{schema: schema} do
      data = nil
      assert valid?(schema, data)
    end

    test "not null is invalid", %{schema: schema} do
      data = 0
      refute valid?(schema, data)
    end
  end
end

defmodule Draft6.TypeTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "integer type matches integers" do
    setup do
      %{schema: ~s(
        {
          "type": "integer"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is an integer", %{schema: schema} do
      data = 1
      assert valid?(schema, data)
    end

    test "a float is not an integer", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is not an integer", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "a string is still not an integer, even if it looks like one", %{
      schema: schema
    } do
      data = "1"
      refute valid?(schema, data)
    end

    test "an object is not an integer", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is not an integer", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is not an integer", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is not an integer", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "number type matches numbers" do
    setup do
      %{schema: ~s(
        {
          "type": "number"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is a number", %{schema: schema} do
      data = 1
      assert valid?(schema, data)
    end

    test "a float is a number", %{schema: schema} do
      data = 1.1
      assert valid?(schema, data)
    end

    test "a string is not a number", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "a string is still not a number, even if it looks like one", %{
      schema: schema
    } do
      data = "1"
      refute valid?(schema, data)
    end

    test "an object is not a number", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is not a number", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is not a number", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is not a number", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "string type matches strings" do
    setup do
      %{schema: ~s(
        {
          "type": "string"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "1 is not a string", %{schema: schema} do
      data = 1
      refute valid?(schema, data)
    end

    test "a float is not a string", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is a string", %{schema: schema} do
      data = "foo"
      assert valid?(schema, data)
    end

    test "a string is still a string, even if it looks like a number", %{
      schema: schema
    } do
      data = "1"
      assert valid?(schema, data)
    end

    test "an object is not a string", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is not a string", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is not a string", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is not a string", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "object type matches objects" do
    setup do
      %{schema: ~s(
        {
          "type": "object"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is not an object", %{schema: schema} do
      data = 1
      refute valid?(schema, data)
    end

    test "a float is not an object", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is not an object", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "an object is an object", %{schema: schema} do
      data = %{}
      assert valid?(schema, data)
    end

    test "an array is not an object", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is not an object", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is not an object", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "array type matches arrays" do
    setup do
      %{schema: ~s(
        {
          "type": "array"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is not an array", %{schema: schema} do
      data = 1
      refute valid?(schema, data)
    end

    test "a float is not an array", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is not an array", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "an object is not an array", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is an array", %{schema: schema} do
      data = []
      assert valid?(schema, data)
    end

    test "a boolean is not an array", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is not an array", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "boolean type matches booleans" do
    setup do
      %{schema: ~s(
        {
          "type": "boolean"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is not a boolean", %{schema: schema} do
      data = 1
      refute valid?(schema, data)
    end

    test "a float is not a boolean", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is not a boolean", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "an object is not a boolean", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is not a boolean", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is a boolean", %{schema: schema} do
      data = true
      assert valid?(schema, data)
    end

    test "null is not a boolean", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end

  describe "null type matches only the null object" do
    setup do
      %{schema: ~s(
        {
          "type": "null"
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is not null", %{schema: schema} do
      data = 1
      refute valid?(schema, data)
    end

    test "a float is not null", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "a string is not null", %{schema: schema} do
      data = "foo"
      refute valid?(schema, data)
    end

    test "an object is not null", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is not null", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is not null", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is null", %{schema: schema} do
      data = nil
      assert valid?(schema, data)
    end
  end

  describe "multiple types can be specified in an array" do
    setup do
      %{schema: ~s(
        {
          "type": [
            "integer",
            "string"
          ]
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "an integer is valid", %{schema: schema} do
      data = 1
      assert valid?(schema, data)
    end

    test "a string is valid", %{schema: schema} do
      data = "foo"
      assert valid?(schema, data)
    end

    test "a float is invalid", %{schema: schema} do
      data = 1.1
      refute valid?(schema, data)
    end

    test "an object is invalid", %{schema: schema} do
      data = %{}
      refute valid?(schema, data)
    end

    test "an array is invalid", %{schema: schema} do
      data = []
      refute valid?(schema, data)
    end

    test "a boolean is invalid", %{schema: schema} do
      data = true
      refute valid?(schema, data)
    end

    test "null is invalid", %{schema: schema} do
      data = nil
      refute valid?(schema, data)
    end
  end
end

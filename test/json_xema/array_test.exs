defmodule JsonXema.ArrayTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2, validate: 2]

  describe "'list' schema" do
    setup do
      %{schema: ~s({"type" : "array"}) |> Jason.decode!() |> JsonXema.new()}
    end

    test "validate/2 with an empty list", %{schema: schema} do
      assert validate(schema, []) == :ok
    end

    test "validate/2 with an list of different types", %{schema: schema} do
      assert validate(schema, [1, "bla", 3.4]) == :ok
    end

    test "validate/2 with an invalid value", %{schema: schema} do
      expected = {:error, %{type: "array", value: "not an array"}}

      assert validate(schema, "not an array") == expected
    end

    test "valid?/2 with a valid value", %{schema: schema} do
      assert valid?(schema, [1])
    end

    test "valid?/2 with an invalid value", %{schema: schema} do
      refute valid?(schema, 42)
    end
  end

  describe "'list' schema with size" do
    setup do
      %{schema: ~s({
        "type" : "array",
        "minItems" : 2,
        "maxItems" : 3
      }) |> Jason.decode!() |> JsonXema.new()}
    end

    test "validate/2 with too short list", %{schema: schema} do
      assert validate(schema, [1]) == {:error, %{value: [1], minItems: 2}}
    end

    test "validate/2 with proper list", %{schema: schema} do
      assert validate(schema, [1, 2]) == :ok
    end

    test "validate/2 with to long list", %{schema: schema} do
      assert validate(schema, [1, 2, 3, 4]) ==
               {:error, %{value: [1, 2, 3, 4], maxItems: 3}}
    end
  end

  describe "'list' schema with typed items" do
    setup do
      %{
        integers: ~s({
          "type" : "array",
          "items" : {
            "type" : "integer"
          }
        }) |> Jason.decode!() |> JsonXema.new(),
        strings: ~s({
          "type" : "array",
          "items" : {
            "type" : "string"
          }
        }) |> Jason.decode!() |> JsonXema.new()
      }
    end

    test "validate/2 integers with empty list", %{integers: schema} do
      assert validate(schema, []) == :ok
    end

    test "validate/2 integers with list of integers", %{integers: schema} do
      assert validate(schema, [1, 2]) == :ok
    end

    test "validate/2 integers with invalid list", %{integers: schema} do
      expected = {:error, %{items: [{2, %{type: "integer", value: "foo"}}]}}

      assert validate(schema, [1, 2, "foo"]) == expected
    end

    test "validate/2 strings with empty list", %{strings: schema} do
      assert validate(schema, []) == :ok
    end

    test "validate/2 strings with list of string", %{strings: schema} do
      assert validate(schema, ["foo"]) == :ok
    end

    test "validate/2 strings with invalid list", %{strings: schema} do
      expected = {
        :error,
        %{
          items: [
            {0, %{type: "string", value: 1}},
            {1, %{type: "string", value: 2}}
          ]
        }
      }

      assert validate(schema, [1, 2, "foo"]) == expected
    end
  end

  describe "'list' schema with unique items" do
    setup do
      %{schema: ~s({
        "type" : "array",
        "uniqueItems" : true
      }) |> Jason.decode!() |> JsonXema.new()}
    end

    test "validate/2 with list of unique items", %{schema: schema} do
      assert validate(schema, [1, 2, 3]) == :ok
    end

    test "validate/2 with list of not unique items", %{schema: schema} do
      assert validate(schema, [1, 2, 3, 3, 4]) ==
               {:error, %{value: [1, 2, 3, 3, 4], uniqueItems: true}}
    end
  end

  describe "'list' schema with tuple validation" do
    setup do
      %{
        schema: ~s({
          "type" : "array",
          "items" : [
            {
              "type" : "string",
              "minLength" : 3
            },
            {
              "type" : "number",
              "minimum" : 10
            }
          ]
        }) |> Jason.decode!() |> JsonXema.new()
      }
    end

    test "validate/2 with valid values", %{schema: schema} do
      assert validate(schema, ["foo", 42]) == :ok
    end

    test "validate/2 with invalid values", %{schema: schema} do
      assert validate(schema, ["foo", "bar"]) ==
               {:error, %{items: [{1, %{type: "number", value: "bar"}}]}}

      assert validate(schema, ["x", 33]) ==
               {:error, %{items: [{0, %{value: "x", minLength: 3}}]}}
    end

    test "validate/2 with invalid value and additional item", %{schema: schema} do
      assert validate(schema, ["x", 33, 7]) ==
               {:error, %{items: [{0, %{value: "x", minLength: 3}}]}}
    end

    test "validate/2 with additional item", %{schema: schema} do
      assert validate(schema, ["foo", 42, "add"]) == :ok
    end

    test "validate/2 with missing item", %{schema: schema} do
      assert validate(schema, ["foo"]) == :ok
    end
  end

  describe "'list' schema with tuple validation without additional items" do
    setup do
      %{
        schema: ~s({
          "type" : "array",
          "additionalItems" : false,
          "items" : [
            {
              "type" : "string",
              "minLength" : 3
            },
            {
              "type" : "number",
              "minimum" : 10
            }
          ]
        }) |> Jason.decode!() |> JsonXema.new()
      }
    end

    test "validate/2 with additional item", %{schema: schema} do
      assert validate(schema, ["foo", 42, "add"]) ==
               {:error, %{items: [{2, %{additionalItems: false}}]}}
    end
  end

  describe "list schema with with specific additional items" do
    setup do
      %{
        schema: ~s({
          "type" : "array",
          "additionalItems" : {
            "type" : "string"
          },
          "items" : [
            {
              "type" : "number",
              "minimum" : 10
            }
          ]
        }) |> Jason.decode!() |> JsonXema.new()
      }
    end

    test "validate/2 with valid additional item", %{schema: schema} do
      assert validate(schema, [11, "twelve", "thirteen"]) == :ok
    end

    test "validate/2 with invalid additional item", %{schema: schema} do
      assert validate(schema, [11, "twelve", 13]) ==
               {:error, %{items: [{2, %{type: "string", value: 13}}]}}
    end
  end
end

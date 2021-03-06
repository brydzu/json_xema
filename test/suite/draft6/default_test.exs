defmodule Draft6.DefaultTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "invalid type for default" do
    setup do
      %{schema: ~s(
        {
          "properties": {
            "foo": {
              "default": [],
              "type": "integer"
            }
          }
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "valid when property is specified", %{schema: schema} do
      data = %{"foo" => 13}
      assert valid?(schema, data)
    end

    test "still valid when the invalid default is used", %{schema: schema} do
      data = %{}
      assert valid?(schema, data)
    end
  end

  describe "invalid string value for default" do
    setup do
      %{schema: ~s(
        {
          "properties": {
            "bar": {
              "default": "bad",
              "minLength": 4,
              "type": "string"
            }
          }
        }
        ) |> Jason.decode!() |> JsonXema.new()}
    end

    test "valid when property is specified", %{schema: schema} do
      data = %{"bar" => "good"}
      assert valid?(schema, data)
    end

    test "still valid when the invalid default is used", %{schema: schema} do
      data = %{}
      assert valid?(schema, data)
    end
  end
end

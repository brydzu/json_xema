defmodule JsonXema.ToXema do
  use ExUnit.Case, async: true

  describe "to_xema/1 converts JsonXema to Xema:" do
    @tag :only
    test "any schema" do
      schema = JsonXema.new(~s({}))
      expected = "Xema.new(:any)"

      assert convert(schema) == expected
    end

    test "list schema" do
      schema = JsonXema.new(~s(
        {
          "type": "array",
          "items": [
            {"type": "string"},
            {"type": "number", "minimum": 4}
          ]
        }
      ))
      expected = "Xema.new(:list, items: [:string, {:number, minimum: 4}])"

      assert convert(schema) == expected
    end

    test "object schema" do
      schema = JsonXema.new(~s(
        {
          "type": "object",
          "properties": {
            "foo": {"type": "string"},
            "bar": {"type": "number", "maximum": 4}
          }
        }
      ))

      expected =
        :map
        |> Xema.new(
          properties: %{
            "bar" => {:number, maximum: 4},
            "foo" => :string
          }
        )
        |> Xema.to_string(format: :call)

      assert convert(schema) == expected
    end

    test "multi type" do
      schema = JsonXema.new(~s(
        {"type": ["integer", "null"]}
      ))

      expected =
        [:integer, nil]
        |> Xema.new()
        |> Xema.to_string()

      assert convert(schema) == expected
    end
  end

  defp convert(json_xema),
    do:
      json_xema
      |> JsonXema.to_xema()
      |> Xema.to_string(format: :call)
end
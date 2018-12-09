defmodule Draft7.MaxItemsTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "maxItems validation" do
    setup do
      %{schema: JsonXema.new(~s(
        {
          "maxItems": 2
        }
      ))}
    end

    test "shorter is valid", %{schema: schema} do
      data = [1]
      assert valid?(schema, data)
    end

    test "exact length is valid", %{schema: schema} do
      data = [1, 2]
      assert valid?(schema, data)
    end

    test "too long is invalid", %{schema: schema} do
      data = [1, 2, 3]
      refute valid?(schema, data)
    end

    test "ignores non-arrays", %{schema: schema} do
      data = "foobar"
      assert valid?(schema, data)
    end
  end
end
defmodule Draft6.MinItemsTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "minItems validation" do
    setup do
      %{schema: JsonXema.new(~s( {"minItems":1} ))}
    end

    test "longer is valid", %{schema: schema} do
      data = [1, 2]
      assert is_valid?(schema, data)
    end

    test "exact length is valid", %{schema: schema} do
      data = [1]
      assert is_valid?(schema, data)
    end

    test "too short is invalid", %{schema: schema} do
      data = []
      refute is_valid?(schema, data)
    end

    test "ignores non-arrays", %{schema: schema} do
      data = ""
      assert is_valid?(schema, data)
    end
  end
end

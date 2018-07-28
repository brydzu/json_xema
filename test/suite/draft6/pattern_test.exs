defmodule Draft6.PatternTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "pattern validation" do
    setup do
      %{schema: JsonXema.new(~s( {"pattern":"^a*$"} ))}
    end

    test "a matching pattern is valid", %{schema: schema} do
      data = "aaa"
      assert is_valid?(schema, data)
    end

    test "a non-matching pattern is invalid", %{schema: schema} do
      data = "abc"
      refute is_valid?(schema, data)
    end

    test "ignores non-strings", %{schema: schema} do
      data = true
      assert is_valid?(schema, data)
    end
  end

  describe "pattern is not anchored" do
    setup do
      %{schema: JsonXema.new(~s( {"pattern":"a+"} ))}
    end

    test "matches a substring", %{schema: schema} do
      data = "xxaayy"
      assert is_valid?(schema, data)
    end
  end
end

defmodule Draft4.AllOfTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "allOf" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"allOf":[{"properties":{"bar":{"type":"integer"}},"required":["bar"]},{"properties":{"foo":{"type":"string"}},"required":["foo"]}]} )
          )
      }
    end

    test "allOf", %{schema: schema} do
      data = %{bar: 2, foo: "baz"}
      assert is_valid?(schema, data)
    end

    test "mismatch second", %{schema: schema} do
      data = %{foo: "baz"}
      refute is_valid?(schema, data)
    end

    test "mismatch first", %{schema: schema} do
      data = %{bar: 2}
      refute is_valid?(schema, data)
    end

    test "wrong type", %{schema: schema} do
      data = %{bar: "quux", foo: "baz"}
      refute is_valid?(schema, data)
    end
  end

  describe "allOf with base schema" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"allOf":[{"properties":{"foo":{"type":"string"}},"required":["foo"]},{"properties":{"baz":{"type":"null"}},"required":["baz"]}],"properties":{"bar":{"type":"integer"}},"required":["bar"]} )
          )
      }
    end

    test "valid", %{schema: schema} do
      data = %{bar: 2, baz: nil, foo: "quux"}
      assert is_valid?(schema, data)
    end

    test "mismatch base schema", %{schema: schema} do
      data = %{baz: nil, foo: "quux"}
      refute is_valid?(schema, data)
    end

    test "mismatch first allOf", %{schema: schema} do
      data = %{bar: 2, baz: nil}
      refute is_valid?(schema, data)
    end

    test "mismatch second allOf", %{schema: schema} do
      data = %{bar: 2, foo: "quux"}
      refute is_valid?(schema, data)
    end

    test "mismatch both", %{schema: schema} do
      data = %{bar: 2}
      refute is_valid?(schema, data)
    end
  end

  describe "allOf simple types" do
    setup do
      %{schema: JsonXema.new(~s( {"allOf":[{"maximum":30},{"minimum":20}]} ))}
    end

    test "valid", %{schema: schema} do
      data = 25
      assert is_valid?(schema, data)
    end

    test "mismatch one", %{schema: schema} do
      data = 35
      refute is_valid?(schema, data)
    end
  end
end
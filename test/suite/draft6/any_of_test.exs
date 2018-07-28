defmodule Draft6.AnyOfTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "anyOf" do
    setup do
      %{
        schema: JsonXema.new(~s( {"anyOf":[{"type":"integer"},{"minimum":2}]} ))
      }
    end

    test "first anyOf valid", %{schema: schema} do
      data = 1
      assert is_valid?(schema, data)
    end

    test "second anyOf valid", %{schema: schema} do
      data = 2.5
      assert is_valid?(schema, data)
    end

    test "both anyOf valid", %{schema: schema} do
      data = 3
      assert is_valid?(schema, data)
    end

    test "neither anyOf valid", %{schema: schema} do
      data = 1.5
      refute is_valid?(schema, data)
    end
  end

  describe "anyOf with base schema" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"anyOf":[{"maxLength":2},{"minLength":4}],"type":"string"} )
          )
      }
    end

    test "mismatch base schema", %{schema: schema} do
      data = 3
      refute is_valid?(schema, data)
    end

    test "one anyOf valid", %{schema: schema} do
      data = "foobar"
      assert is_valid?(schema, data)
    end

    test "both anyOf invalid", %{schema: schema} do
      data = "foo"
      refute is_valid?(schema, data)
    end
  end

  describe "anyOf with boolean schemas, all true" do
    setup do
      %{schema: JsonXema.new(~s( {"anyOf":[true,true]} ))}
    end

    test "any value is valid", %{schema: schema} do
      data = "foo"
      assert is_valid?(schema, data)
    end
  end

  describe "anyOf with boolean schemas, some true" do
    setup do
      %{schema: JsonXema.new(~s( {"anyOf":[true,false]} ))}
    end

    test "any value is valid", %{schema: schema} do
      data = "foo"
      assert is_valid?(schema, data)
    end
  end

  describe "anyOf with boolean schemas, all false" do
    setup do
      %{schema: JsonXema.new(~s( {"anyOf":[false,false]} ))}
    end

    test "any value is invalid", %{schema: schema} do
      data = "foo"
      refute is_valid?(schema, data)
    end
  end

  describe "anyOf complex types" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"anyOf":[{"properties":{"bar":{"type":"integer"}},"required":["bar"]},{"properties":{"foo":{"type":"string"}},"required":["foo"]}]} )
          )
      }
    end

    test "first anyOf valid (complex)", %{schema: schema} do
      data = %{bar: 2}
      assert is_valid?(schema, data)
    end

    test "second anyOf valid (complex)", %{schema: schema} do
      data = %{foo: "baz"}
      assert is_valid?(schema, data)
    end

    test "both anyOf valid (complex)", %{schema: schema} do
      data = %{bar: 2, foo: "baz"}
      assert is_valid?(schema, data)
    end

    test "neither anyOf valid (complex)", %{schema: schema} do
      data = %{bar: "quux", foo: 2}
      refute is_valid?(schema, data)
    end
  end
end

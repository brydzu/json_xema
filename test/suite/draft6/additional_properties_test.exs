defmodule Draft6.AdditionalPropertiesTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "additionalProperties being false does not allow other properties" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"additionalProperties":false,"patternProperties":{"^v":{}},"properties":{"bar":{},"foo":{}}} )
          )
      }
    end

    test "no additional properties is valid", %{schema: schema} do
      data = %{foo: 1}
      assert is_valid?(schema, data)
    end

    test "an additional property is invalid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: "boom"}
      refute is_valid?(schema, data)
    end

    test "ignores arrays", %{schema: schema} do
      data = [1, 2, 3]
      assert is_valid?(schema, data)
    end

    test "ignores strings", %{schema: schema} do
      data = "foobarbaz"
      assert is_valid?(schema, data)
    end

    test "ignores other non-objects", %{schema: schema} do
      data = 12
      assert is_valid?(schema, data)
    end

    test "patternProperties are not additional properties", %{schema: schema} do
      data = %{foo: 1, vroom: 2}
      assert is_valid?(schema, data)
    end
  end

  describe "non-ASCII pattern with additionalProperties" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"additionalProperties":false,"patternProperties":{"^á":{}}} )
          )
      }
    end

    test "matching the pattern is valid", %{schema: schema} do
      data = %{ármányos: 2}
      assert is_valid?(schema, data)
    end

    test "not matching the pattern is invalid", %{schema: schema} do
      data = %{élmény: 2}
      refute is_valid?(schema, data)
    end
  end

  describe "additionalProperties allows a schema which should validate" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"additionalProperties":{"type":"boolean"},"properties":{"bar":{},"foo":{}}} )
          )
      }
    end

    test "no additional properties is valid", %{schema: schema} do
      data = %{foo: 1}
      assert is_valid?(schema, data)
    end

    test "an additional valid property is valid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: true}
      assert is_valid?(schema, data)
    end

    test "an additional invalid property is invalid", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: 12}
      refute is_valid?(schema, data)
    end
  end

  describe "additionalProperties can exist by itself" do
    setup do
      %{schema: JsonXema.new(~s( {"additionalProperties":{"type":"boolean"}} ))}
    end

    test "an additional valid property is valid", %{schema: schema} do
      data = %{foo: true}
      assert is_valid?(schema, data)
    end

    test "an additional invalid property is invalid", %{schema: schema} do
      data = %{foo: 1}
      refute is_valid?(schema, data)
    end
  end

  describe "additionalProperties are allowed by default" do
    setup do
      %{schema: JsonXema.new(~s( {"properties":{"bar":{},"foo":{}}} ))}
    end

    test "additional properties are allowed", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: true}
      assert is_valid?(schema, data)
    end
  end
end

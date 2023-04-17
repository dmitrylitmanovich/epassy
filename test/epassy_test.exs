defmodule EpassyTest do
  use ExUnit.Case
  doctest Epassy

  setup do
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase:  Enum.map(?A..?Z, & <<&1>>),
      symbols: String.split("!#$%&()*+_,./@:;<=>?[]{|}^~`", "", trim: true)
    }

    { :ok, result } = Epassy.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "Return a string", %{ result: result } do
    assert is_bitstring(result)
  end

  test "Return a error when no lenght is given" do
    options = %{ "invalid" => "false" }

    assert { :error, _error } = Epassy.generate(options)
  end

  test "Return an error when length is not an Integer" do
    options = %{ "length" => "string" }

    assert { :error, _error } = Epassy.generate(options)
  end

  test "Is length of returned string is the option provided" do
    length_option = %{ "length" => "5" }
    { :ok, result } = Epassy.generate(length_option)

    assert 5 = String.length(result)
  end

  test "Return a lowercase string just with the length", %{ options_type: options } do
    length_option = %{ "length" => "5" }
    { :ok, result } = Epassy.generate(length_option)

    assert String.contains?(result, options.lowercase)

    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  test "Return an error when options values are not Booleans" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "1"
    }

    assert { :error, _error } = Epassy.generate(options)
  end

  test "Return an error when options are not allowed" do
    options = %{ "length" => 10 }


    assert { :error, _error } = Epassy.generate(options)
  end

  test "Return an error when 1 option is not allowed" do
    options = %{ "length" => 5, "numbers" => "true", "invalid" => "true" }

    assert { :error, _error } = Epassy.generate(options)
  end
end

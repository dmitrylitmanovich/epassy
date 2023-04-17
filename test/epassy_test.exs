defmodule EpassyTest do
  use ExUnit.Case

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
    options = %{ "length" => "10", "invalid" => "true" }


    assert { :error, _error } = Epassy.generate(options)
  end

  test "Return an error when 1 option is not allowed" do
    options = %{ "length" => "5", "numbers" => "true", "invalid" => "true" }

    assert { :error, _error } = Epassy.generate(options)
  end

  test "Return a string with uppercase", %{ options_type: options } do
    options_with_uppercase = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "true",
      "symbols" => "false"
    }

    { :ok, result } = Epassy.generate(options_with_uppercase)

    assert String.contains?(result, options.uppercase)

    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end

  test "Return a string with numbers", %{ options_type: options } do
    options_with_numbers = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "false"
    }

    { :ok, result } = Epassy.generate(options_with_numbers)

    assert String.contains?(result, options.numbers)

    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end

  test "Return a string with uppercase and numbers", %{ options_type: options } do
    options_included = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "false"
    }

    { :ok, result } = Epassy.generate(options_included)

    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.uppercase)

    refute String.contains?(result, options.symbols)
  end

  test "Return a string with symbols", %{ options_type: options } do
    options_with_symbols = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "true"
    }

    { :ok, result } = Epassy.generate(options_with_symbols)

    assert String.contains?(result, options.symbols)

    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
  end

  test "Return a string with everything", %{ options_type: options } do
    options_with_all = %{
      "length" => "10",
      "numbers" => "true",
      "uppercase" => "true",
      "symbols" => "true"
    }

    { :ok, result } = Epassy.generate(options_with_all)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.symbols)
  end
end

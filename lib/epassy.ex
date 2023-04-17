defmodule Epassy do
  @moduledoc """
  Generates a random password.
  Module main function is `generate(options)`.
  Options example:
    options = %{
      "length" => "12",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }
  The options are only 4, "length", "numbers", "uppercase", "symbols".
  """

  @allowed_options [:length, :numbers, :uppercase, :symbols]

  @doc """
  Generates a password for given options:

  ## Examples
    options = %{
      "length" => "12",
      "numbers" => "true",
      "uppercase" => "false",
      "symbols" => "true"
    }

    iex> Epassy.generate(options)
    "generated1password2string"
  """

  @spec generate(options :: map()) :: { :ok, bitstring() } | { :error, bitstring() }
  def generate(options) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end

  defp validate_length(false, _options), do: { :error, "Please provide a length" }

  defp validate_length(true, options) do
    numbers = Enum.map(0..9, & Integer .to_string(&1))
    length = options["length"]
    length = String.contains?(length, numbers)
    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _options), do: { :error, "Only integers allow for the length" }

  defp validate_length_is_integer(true, options) do
    length = options["length"] |> String.trim() |> String.to_integer()
    options_without_length = Map.delete(options, "length")
    options_values = Map.values(options_without_length)
    value =
      options_values
      |> Enum.all?(fn x -> String.to_atom(x) |> is_boolean() end)

    validate_option_values_are_booleans(value, length, options_without_length)
  end

  defp validate_option_values_are_booleans(false, _length, _options), do: { :error, "Only booleans allowed for option values" }

  defp validate_option_values_are_booleans(true, length, options) do
    options = included_options(options)
    invalid_options? = options |> Enum.any?(&(&1 not in @allowed_options))

    validate_options(invalid_options?, length, options)
  end

  defp included_options(options) do
    Enum.filter(options, fn { _key, value } ->
      value |> String.trim() |> String.to_existing_atom()
    end)
    |> Enum.map(fn { key, _value } -> String.to_atom(key) end)
  end

  defp validate_options(true, _length, _options), do: { :error, "Only options allowed numbers, upercase, symbols" }

  defp validate_options(false, length, options) do
    generate_strings(length, options)
  end

  defp generate_strings(length, options) do
    options = [:lowercase_letter | options]
    included = include(options)
    length = length - length(included)
    random_strings = generate_random_strings(length, options)
    strings = included ++ random_strings
    get_results(strings)
  end

  defp include(options) do
    options
    |> Enum.map(&get(&1))
  end

  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp generate_random_strings(length, options) do
    Enum.map(1..length, fn _ ->
      Enum.random(options) |> get()
    end)
  end

  defp get_results(strings) do
    string =
      strings
      |> Enum.shuffle()
      |> to_string()

    { :ok, string }
  end
end

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
    "generatedpasswordstring"
  """
  def hello do
    :world
  end
end

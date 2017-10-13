defmodule ClabeValidator do
  @moduledoc """
  Validate and generate checksum.
  [CLABE](https://es.wikipedia.org/wiki/CLABE#D.C3.ADgito_control)
  """

  @doc """
  Validate clabe
  ## Examples

          iex> ClabeValidator.validate("002180435001047924")
          true

          iex> ClabeValidator.validate("002180435001047929")
          false
  """
  @spec validate(String.t) :: boolean
  def validate(clabe) do
    {bank_code, region_code, account, numero_verificador} = split_clabe(clabe)

    validate(bank_code, region_code, account, numero_verificador)
  end

  @spec validate(String.t, String.t, String.t, String.t) :: boolean
  def validate(bank_code, region_code, account, numero_verificador) do
    numero_verificador == generate_checksum(bank_code, region_code, account)
  end

  @doc """
  Generate checksum

  ## Examples

        iex> ClabeValidator.generate_checksum("002180435001047924")
        4

        iex> ClabeValidator.generate_checksum("002180435001047929")
        4
  """
  @spec generate_checksum(String.t) :: number
  def generate_checksum(clabe) do
    {bank_code, region_code, account, _} = split_clabe(clabe)

    generate_checksum(bank_code, region_code, account)
  end

  @spec generate_checksum(String.t, String.t, String.t) :: number
  defp generate_checksum(bank_code, region_code, account) do
    clabe = bank_code <> region_code <> account

    code =
      [3, 7, 1]
      |> List.duplicate(6)
      |> List.flatten

    clabe
    |> String.split("", trim: true)
    |> Enum.map(fn num ->
                {num_int, _} = Integer.parse(num)
                num_int
              end)
    |> Enum.zip(code)
    |> Enum.map(fn {x, y} -> rem(x * y, 10) end)
    |> Enum.sum
    |> rem(10)
    |> Kernel.-(10)
    |> rem(10)
    |> abs
  end

  # Slice clabe to get bank_code, region_code, account and checksum
  @spec split_clabe(String.t) :: tuple
  defp split_clabe(clabe) do
    {
      get_bank_code(clabe),
      get_region_code(clabe),
      get_account(clabe),
      get_checksum(clabe)
    }
  end

  @doc """
  Gets bank code
  """
  @spec get_bank_code(String.t) :: String.t
  def get_bank_code(clabe), do: String.slice(clabe, 0, 3)

  # Returns region_code
  defp get_region_code(clabe), do: String.slice(clabe, 3, 3)

  # Returns account
  defp get_account(clabe), do: String.slice(clabe, 6, 11)

  # Returns checksum
  defp get_checksum(clabe) do
    checksum_parsed =
      clabe
      |> String.slice(17, 1)
      |> Integer.parse

    case checksum_parsed do
      {numero_verificador, _} -> numero_verificador
      :error									-> ""
    end
  end
end

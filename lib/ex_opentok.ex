defmodule ExOpentok do
  @moduledoc """
  REST API wrapper to communicate with ExOpentok signaling server.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ExOpentok.hello
      :world

  """

  require Logger

  @version "0.2.0"

  @api_url "https://api.opentok.com/v2/project/"

  def hello do
    :world
  end

  @doc false
  def version, do: @version

  def api_url, do: @api_url

  # GUARD CLAUSES
  unless Application.get_env(:ex_opentok, ExOpentok) do
    raise "ExOpentok is not configured"
  end

  unless Keyword.get(Application.get_env(:ex_opentok, ExOpentok), :key) do
    raise "ExOpentok requires :key to be configured"
  end

  unless Keyword.get(Application.get_env(:ex_opentok, ExOpentok), :secret) do
    raise "ExOpentok requires :secret to be configured"
  end

  # CONFIG

  @doc false
  def config, do: Application.get_env(:open_tok_sdk, ExOpentok)

  @doc false
  def config(key, default \\ nil), do: config() |> Keyword.get(key, default) |> resolve_config(default)

  defp allowed_algos, do: config(:allowed_algos, @default_algos)

  defp resolve_config({:system, var_name}, default), do: System.get_env(var_name) || default

  defp resolve_config(value, _default), do: value
end

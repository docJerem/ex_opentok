defmodule ExOpentok.Client do
  require Logger
  # use HTTPoison.Base
  alias ExOpentok.Token
  alias ExOpentok.Exception

  @moduledoc """
  Wrapper for HTTPotion
  """

  @doc """
  HTTP Client's request with HTTPotion.
  """
  def http_request(url, type \\ :get, body \\ nil) do
    HTTPotion.start()
    case type do
      :get ->
        HTTPotion.get(url, [
          headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
        ])
      :post ->
        if body do
          HTTPotion.post(url, [
            body: body,
            headers: ["X-OPENTOK-AUTH": Token.jwt(), "Accept": "application/json"]
          ])
        else
          HTTPotion.post(url, [
            headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
          ])
        end

      :delete ->
        HTTPotion.delete(url, [
          headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
        ])
    end
  end

  @doc """
  Handle response 200 and parse body to JSON.
  """
  def handle_response(response) do
    case response do
      %{status_code: 200, body: body} ->
        body |> Poison.decode!() |> handle_data_struct()
      %{status_code: 405, body: body} ->
        raise "405 Method not allowed"
      _ ->
        raise "Error #{response.status_code} -> ExOpentok query:\n #{inspect(response)}"
    end
  end

  defp handle_data_struct(data) do
    if is_list(data), do: List.first(data), else: data
  end
end

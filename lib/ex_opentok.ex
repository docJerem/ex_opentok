defmodule ExOpentok do
  @moduledoc """
  REST API wrapper to communicate with ExOpentok signaling server.
  """

  require Logger

  @version "0.2.0"

  @api_url "https://api.opentok.com/v2/project/"

  @doc """
  init()

  ## Examples

      iex(1)> ExOpentok.init()
      %{:api_key => "01234567",
        :token => "T1==cGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3NcGFydG5lcl9pZD00NTgxMTExMiZzaWc9OUVBOTIyQjlFQzM0NUIxNkI3N==",
        "create_dt" => "Tue Apr 11 08:56:40 PDT 2017",
        "ice_credential_expiration" => 86100, "ice_server" => nil,
        "ice_servers" => nil, "media_server_hostname" => nil,
        "media_server_url" => "", "messaging_server_url" => nil,
        "messaging_url" => nil, "partner_id" => "01234567",
        "project_id" => "01234567", "properties" => nil,
        "session_id" => "1_MX40MX40NTgxMMX40NTgxMMX40NTgxMMX40NTgxMMX40NTgxMMX40NTg",
        "session_status" => nil, "status_invalid" => nil, "symphony_address" => nil}

  """
  def init do
    ExOpentok.Session.init()
  end

  @doc false
  def version, do: @version

  def api_url, do: @api_url

  # CONFIG
  @doc false
  def config(key), do: Application.get_env(:ex_opentok, key)
end

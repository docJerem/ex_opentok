defmodule ExOpentok.Session do
  @moduledoc """
  ExOpentok to create a session
  """

  require Logger
  # use HTTPoison.Base
  alias ExOpentok.Client
  alias ExOpentok.Token

  @doc """
  Create new WebRTC session.

  POST Parameters

  archiveMode
  Set to "always" to have the session archived automatically. With the archiveModeset to manual (the default), you can archive the session by calling the REST /archive POST method. If you set the archiveMode to always, you must also set the p2p.preference parameter to disabled (the default).

  location
  The IP address that TokBox will use to situate the session in its global network. If no location hint is passed in (which is recommended), the session uses a media server based on the location of the first client connecting to the session. Pass a location hint in only if you know the general geographic region (and a representative IP address) and you think the first client connecting may not be in that region. Specify an IP address that is representative of the geographical location for the session.

  p2p.preference
  Set to enabled if you prefer clients to attempt to send audio-video streams directly to other clients; set to disabled for sessions that use the OpenTok Media Router. (Optional; the default setting is disabled -- the session uses the OpenTok Media Router.)

  The OpenTok Media Router provides the following benefits:

  The OpenTok Media Router can decrease bandwidth usage in multiparty sessions. (When the p2p.preference property is set to enabled, each client must send a separate audio-video stream to each client subscribing to it.)
  The OpenTok Media Router can improve the quality of the user experience using audio fallback and video recovery. With these features, if a client's connectivity degrades to a degree that it does not support video for a stream it's subscribing to, the video is dropped on that client (without affecting other clients), and the client receives audio only. If the client's connectivity improves, the video returns.
  The OpenTok Media Router supports the archiving feature, which lets you record, save, and retrieve OpenTok sessions.
  With the p2p.preference property set to "enabled", the session will attempt to transmit streams directly between clients. If clients cannot connect due to firewall restrictions, the session uses the OpenTok TURN server to relay audio-video streams.
  """
  def create(opts \\ %{media_mode: "routed", archive_mode: "manual", location: nil}) do
    "https://api.opentok.com/session/create"
    |> Client.http_request(:post, http_body(opts))
    |> Client.handle_response()
  end

  defp format_response(session) do
    Map.merge(session,
                %{
                  api_key: ExOpentok.config(:key),
                  token: Token.generate(session["session_id"])
                }
              )
  end

  def init, do: create() |> format_response()

  @doc """
  Handle location
  """
  defp location(opts) do
    cond do
      opts.location == nil || opts.location == "" ->
        ""
      valid_ip?(opts.location) ->
        "location=#{opts.location}&"
      true ->
        raise "ip format incorrect or let location empty"
    end
  end

  defp valid_ip?(ip), do: :re.run(ip, "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$") != :nomatch

  @doc """
  Handle media mode
  """
  defp mode(opts \\ %{media_mode: "routed", archive_mode: "manual", location: nil}) do
    case opts do
    %{media_mode: "routed"} ->
      "p2p.preference=disabled"
    %{archive_mode: "always"} ->
      "archiveMode&p2p.preference=disabled"
    %{media_mode: "relayed", location: ip} ->
      "p2p.preference=enabled"
    _ ->
      raise "You need to set media mode to relayed or routed"
    end
  end

  @doc """
  Generate http body for post to rest api
  """
  defp http_body(opts), do: location(opts) <> mode(opts)

  def delete(session_id, connection_id) do
    ExOpentok.api_url() <> "/#{ExOpentok.config(:key)}/session/#{session_id}/connection/#{connection_id}"
    |> Client.http_request()
    |> Client.handle_response()
  end

end

defmodule ExOpentok.Archive do
  @derive [Poison.Encoder]
  require Logger
  alias ExOpentok.Token
  alias ExOpentok.Client

  @moduledoc """
  Add recording and playback to the application using JavaScript.
  """

  defstruct sessionId: 0,
            hasAudio: true,
            hasVideo: true,
            name: "",
            outputMode: "composed"

  @doc """
  The JSON object includes the following properties:

  sessionId (String) — (Required) The session ID of the OpenTok session you want to start archiving
  hasAudio (Boolean) — (Optional) Whether the archive will record audio (true, the default) or not (false). If you set both hasAudio and hasVideo to false, the call to this method results in an error.
  hasVideo (Boolean) — (Optional) Whether the archive will record video (true, the default) or not (false). If you set both hasAudio and hasVideo to false, the call to this method results in an error.
  name (String) — (Optional) The name of the archive (for your own identification)
  outputMode (String) — (Optional) Whether all streams in the archive are recorded to a single file ("composed", the default) or to individual files ("individual").
  """
  def start(sessionId) do
    IO.inspect(sessionId)
    HTTPotion.start()
    response = HTTPotion.post(ExOpentok.api_url() <> "/#{ExOpentok.config(:key)}/archive", [
        body: '{"sessionId" : "#{sessionId}", "name" : "#{generate_name()}"}',
        headers: ["X-OPENTOK-AUTH": Token.jwt(), "Content-Type": "application/json"]
      ])
    case response do
      %{status_code: 200, body: body} ->
        body |> Poison.decode!()
      %{status_code: 400} ->
        Logger.error fn -> "Error 400 The archive could not be started. The request was invalid or the session has no connected clients." end
        {:error, ExOpentok.Exception}
      %{status_code: 403, body: body} ->
        Logger.error fn -> "Error 403 Authentication failed while starting an archive. API Key: #{ExOpentok.config(:key)}" end
      %{status_code: 404, body: body} ->
        Logger.error fn -> "Error 404 The archive could not be started. The Session ID does not exist: #{sessionId}" end
      %{status_code: 409, body: body} ->
        Logger.error fn -> "Error 409 The archive could not be started. The session could be peer-to-peer or the session is already being recorded." end
      %{status_code: 415, body: body} ->
        Logger.error fn -> "Error 415 Server is not able to process the Content-Type of the request." end

      _ ->
        Logger.error fn -> "The archive could not be started" end
        {:error, ExOpentok.Exception}
    end
  end

  defp generate_name, do: "archive-" <> ExOpentok.config(:key) <> "-" <> UUID.uuid4()

  @doc """
  Stopping an archive recording

  To stop recording an archive, submit an HTTP POST request.

  Archives stop recording after 2 hours (120 minutes), or 60 seconds after the last
  client disconnects from the session, or 60 minutes after the last client stops
  publishing.
  However, <a href="developer/guides/archiving/#automatic-archives> automatic archives
  continue recording to multiple consecutive files of up to 2 hours in length each.

  Calling this method for automatic archives has no effect. Automatic archives continue
  recording to multiple consecutive files of up to 2 hours in length each, until
  60 seconds after the last client disconnects from the session, or 60 minutes after
  the last client stops publishing a stream to the session.
  """
  def stop(archive_id) do
    ExOpentok.api_url() <> "#{ExOpentok.config(:key)}/archive/#{archive_id}/stop"
    |> Client.http_request(:post)
    |> Client.handle_response()
  end

  @doc """
  Deleting an archive

  To delete an archive, submit an HTTP DELETE request.

  You can only delete an archive which has a status of "available" or "uploaded".
  Deleting an archive removes its record from the list of archives (see Listing archives).
  For an "available" archive, it also removes the archive file, making it unavailable for download.
  """
  def delete(archive_id) do
    ExOpentok.api_url() <> "#{ExOpentok.config(:key)}/archive/#{archive_id}"
    |> Client.http_request(:delete)
    |> Client.handle_response()
  end

  @doc """
  Listing archives

  To list archives for your API key, both completed and in-progress, submit an
  HTTP GET request.

  iex(1)> ExOpentok.Archive.list()
  %{"count" => 2,
    "items" => [%{"createdAt" => 1491851152000, "duration" => 2,
       "hasAudio" => true, "hasVideo" => true,

       "id" => "01234567-0123-0123-0123-012345678901",
       "name" => "archive-45811112-e44e2c5f-c885-45a4-b9be-0143d28c1ddf",
       "outputMode" => "composed", "partnerId" => 45811112, "password" => "",
       "projectId" => 01234567, "reason" => "user initiated",
       "sessionId" => "2_MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40",
       "sha256sum" => "2_MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40",
       "size" => 163575, "status" => "available", "updatedAt" => 1491851160000,
       "url" => "https://s3.amazonaws.com/tokbox.com.archive2/01234567/01234567-0123-0123-0123-012345678901/archive.mp4?AWSAccessKeyId=01234567-0123-0123-0123-012345678901Expires=01234567-0123-0123-0123-012345678901&Signature=01234567-0123-0123-0123-012345678901"},
     %{"createdAt" => 1491682306000, "duration" => 21, "hasAudio" => true,
       "hasVideo" => true, "id" => "01234567-0123-0123-0123-012345678901",
       "name" => "Elixir Archiving Sample App", "outputMode" => "composed",
       "partnerId" => 45811112, "password" => "", "projectId" => 01234567,
       "reason" => "user initiated",
       "sessionId" => "2_MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40",
       "sha256sum" => "2_MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40MX40",
       "size" => 1742751, "status" => "available", "updatedAt" => 1491682333000,
       "url" => "https://s3.amazonaws.com/tokbox.com.archive2/01234567/01234567-0123-0123-0123-012345678901/archive.mp4?AWSAccessKeyId=01234567-0123-0123-0123-012345678901Expires=01234567-0123-0123-0123-012345678901&Signature=01234567-0123-0123-0123-012345678901"}]}

  """
  def list(opts \\ %{offset: 0, count: 1000}) do
    ExOpentok.api_url() <> "#{ExOpentok.config(:key)}/archive?offset=#{opts.offset}&count=#{opts.count}"
    |> Client.http_request()
    |> Client.handle_response()
  end

  def find(archive_id) do
    ExOpentok.api_url() <> "#{ExOpentok.config(:key)}/archive/#{archive_id}"
    |> Client.http_request()
    |> Client.handle_response()
  end

end

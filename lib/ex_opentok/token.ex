defmodule ExOpentok.Token do
  @moduledoc """
  ExOpentok Token ToolBox
  """

  @default_algos ["HS256"]
  @role_publisher "publisher"
  @token_prefix "T1=="

  @doc """
  Generate unique token to access session.
  """
  def generate(session_id) do
    session_id
    |> data_content()
    |> token_process(session_id)
  end

  defp data_content(session_id) do
    "session_id=#{session_id}&create_time=#{:os.system_time(:seconds)}&role=publisher&nonce=#{nonce()}"
  end

  defp token_process(data_content, session_id) do
    data_content
    |> sign_string(ExOpentok.config(:secret))
    |> data_string(ExOpentok.config(:ttl))
    |> token(data_content)
  end

  defp token(signature, data_string) do
    @token_prefix <> Base.encode64("partner_id=#{ExOpentok.config(:key)}&sig=#{signature}:#{data_string}")
  end

  defp nonce, do: Base.encode16(:crypto.strong_rand_bytes(16))

  defp data_string(string, expire_time), do: string <> "&expire_time=#{expire_time}"

  @doc """
  Generate JWT to access ExOpentok API services.
  """
  @spec jwt() :: String.t
  def jwt do
    import Joken

    data_from_config()
    |> token()
    |> with_signer(hs256(ExOpentok.config(:secret)))
    |> sign()
    |> get_compact()
  end

  defp data_from_config do
    %{
      iss: ExOpentok.config(:key),
      iat: :os.system_time(:seconds),
      exp: :os.system_time(:seconds) + 300,
      ist: ExOpentok.config(:iss),
      jti: UUID.uuid4()
    }
  end

  @spec sign_string(String.t, String.t) :: String.t
  defp sign_string(string, secret) do
      :sha
      |> :crypto.hmac(secret, string)
      |> Base.encode16
  end
end

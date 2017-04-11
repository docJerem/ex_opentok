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
    |> sign_string(config(:secret))
    |> data_string(config(:ttl))
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

    %{
      iss: ExOpentok.config(:key),
      iat: :os.system_time(:seconds),
      exp: :os.system_time(:seconds) + 300,
      ist: config(:iss, "project")  ,
      jti: UUID.uuid4()
    }
    |> token()
    |> with_signer(hs256(ExOpentok.config(:secret)))
    |> sign()
    |> get_compact()
  end

  # DATA STRING

  # @spec data_string(String.t, nil | String.t, nil | String.t) :: String.t
  # defp data_string(string, nil, nil), do: string
  #
  # defp data_string(string, expire_time, nil), do: string <> "&expire_time=#{expire_time}"
  #
  # defp data_string(string, nil, connection_data), do: string <> "&connection_data=#{URI.encode(connection_data)}"
  #
  # defp data_string(string, expire_time, connection_data) do
  #     string
  #     |> data_string(expire_time, nil)
  #     |> data_string(nil, connection_data)
  # end

  @spec sign_string(String.t, String.t) :: String.t
  defp sign_string(string, secret) do
      :sha
      |> :crypto.hmac(secret, string)
      |> Base.encode16
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

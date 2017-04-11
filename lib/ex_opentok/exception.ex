defmodule ExOpentok.Exception do
  @moduledoc """
  This module contains every exceptions.
  """
  defexception [:message]

  unless ExOpentok.config(:iss) do
    raise "ExOpentok requires :iss to be configured"
  end

  unless ExOpentok.config(:key) do
    raise "ExOpentok requires :key to be configured"
  end

  unless ExOpentok.config(:secret) do
    raise "ExOpentok requires :secret to be configured"
  end

  unless ExOpentok.config(:ttl) do
    raise "ExOpentok requires :ttl to be configured"
  end

end

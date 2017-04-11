defmodule ExOpentok.ApiError do
    @moduledoc """
    Raised in case non 200 response code from OpenTok API.
    """
    defexception [:message]
end

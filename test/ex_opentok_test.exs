defmodule ExOpentokTest do
  use ExUnit.Case
  alias ExOpentokTest.{Helper, Mock}
  alias ExOpentok.{Archive, Client, Exception, Session, Token}

  @api_key ExOpentok.config(:key)
  @session ExOpentok.init()
  @list ExOpentok.Archive.list()

  # ARCHIVE

  # @NB test with selenium in the OpenTok-Phoenix-SDK package: start() stop() delete()

  # Archive.list()
  test "should return a list with a count & items keys" do
    assert Map.has_key?(@list, "count") && Map.has_key?(@list, "items")
  end

  # Archive.find()
  test "should find an archive with a session_id" do
    first_item = @list["items"] |> Enum.at(0)

    first_item["id"]
    |> Archive.find()
    |> Helper.same_map?(Helper.archive_keys())
  end

  # CLIENT
  
  # Client.http_request()
  test "should get 200 when request get" do
    response = Client.http_request("https://api.opentok.com/v2/project/#{@api_key}/archive?offset=0&count=1000", :get)
    assert response.status_code == 200
  end

  # Client.handle_response()
  test "should handle response 200" do
    response = Mock.http_response_archive_list()
    assert Client.handle_response(response) == Mock.archive_list()
  end
  # Client.handle_response()
  test "should raise if no response 200" do
   assert_raise RuntimeError, fn ->
      Mock.http_response_error() |> Client.handle_response()
   end
 end

  # EXCEPTION

  # SESSION (Initialized with no options)

  # Session.start()
  test "should have an api_key property" do
    assert @session.api_key == @api_key
  end

  # Session.start()
  test "should have a token" do
    assert Helper.similar_token?(@session.token)
  end

  # TOKEN

  # Token.jwt()
  test "should return a jwt of 232 bytes" do
    assert Helper.similar_token?(Token.jwt(), 232)
  end

end

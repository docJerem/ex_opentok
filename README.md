# ex_opentok

A Wrapper of Open Tok (Tokbox) API for elixir.

# OpenTok Elixir SDK

The OpenTok Elixir SDK lets you generate
[sessions](http://www.tokbox.com/opentok/tutorials/create-session/) and
[tokens](http://www.tokbox.com/opentok/tutorials/create-token/) for
[OpenTok](http://www.tokbox.com/) applications, and
[archive](https://tokbox.com/opentok/tutorials/archiving) OpenTok sessions.

# Installation

## Hex

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_opentok` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_opentok, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_opentok](https://hexdocs.pm/ex_opentok).
Allow bundler to install the change.

```
$ mix deps.get
```

# Usage

## Initializing

Add a config setting in your config.ex with your OpenTok API key and API secret.

```elixir

config :ex_opentok,
  iss: "project",
  key: System.get_env("OPENTOKSDK_KEY"),
  secret: System.get_env("OPENTOKSDK_SECRET"),
  ttl: 300

```

## Creating Sessions

To create an OpenTok Session, use the `Opentok.init()` or `ExOpentok.Session.create()`  
functions. A map is returned with every informations which could be usefulls
(like sessionId) that can be saved to a persistent store (e.g. database).

```elixir

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

```

## Generating Tokens

Once a Session is created, you can start generating Tokens for clients to use when connecting to it.
You can generate a token either by calling the `ExOpentok.Token.generate(session_id)`.

```elixir

# Generate a Token from just a session_id (fetched from a database)
token = ExOpentok.Token.generate(session_id)

```

## Working with Archives

You can start the recording of an OpenTok Session using the `ExOpentok.Archive.start(session_id)`
method. This will return an `OpenTok::Archive` instance.

```elixir

# Create an Archive
archive = ExOpentok.Archive.start(session_id)

```

You can stop the recording of a started Archive using the `ExOpentok.Archive.stop(archive_id)`
method.

```elixir

# Stop an Archive from an archive_id (fetched from database)
opentok.archives.stop(archive_id)

```

To get an `ExOpentok.Archive` map (and all the information about it) from an `archive_id`, use
the `ExOpentok.Archive.find(archive_id)` method.

```elixir

  iex(1)> ExOpentok.Archive.find(archive_id)

  %{"createdAt" => 1491682306000, "duration" => 21, "hasAudio" => true,
    "hasVideo" => true, "id" => "5c48fb135c48fb13e581d8ed5c48fb13",
    "name" => "Elixir Archiving Sample App", "outputMode" => "composed",
    "partnerId" => 123456789, "password" => "", "projectId" => 123456789,
    "reason" => "user initiated",
    "sessionId" => "1_5c48fb135c48fb135c48fb135c48fb135c48fb135c48fb135c48fb13-fg",
    "sha256sum" => "97+WlyjwonBOTK7FwonBOTK7FwonBOTK7FwonBOTK7Fw=",
    "size" => 1742751, "status" => "expired", "updatedAt" => 1491943883000,
    "url" => nil}

```

To delete an Archive, you can call the `ExOpentok.Archive.delete(archive_id)` method.

```elixir

# Delete an Archive from an archive_id (fetched from database)
  iex(1)> ExOpentok.Archive.delete(archive_id)

```

You can also get a list of all the Archives you've created (up to 1000) with your API Key. This is
done using the `ExOpentok.Archive.list()` function. Parameters `%{offset: 0, count: 1000}` is an optional map
used to specify an `:offset` and `:count` to help you paginate through the results.

```elixir

  iex(1)> ExOpentok.Archive.list()

  # or

  iex(1)> ExOpentok.Archive.list(%{offset: 0, count: 1000})

  %{"count" => 1,
    "items" => [%{"createdAt" => 1491682306000, "duration" => 21,
       "hasAudio" => true, "hasVideo" => true,
       "id" => "5c48fb13-f5c48fb13-5c48fb13",
       "name" => "Ruby Archiving Sample App", "outputMode" => "composed",
       "partnerId" => 45811112, "password" => "", "projectId" => 45811112,
       "reason" => "user initiated",
       "sessionId" => "1_5c48fb135c48fb135c48fb135c48fb135c48fb135c48fb13-fg",
       "sha256sum" => "97+5c48fb135c48fb135c48fb135c48fb135c48fb13=",
       "size" => 1742751, "status" => "expired", "updatedAt" => 1491943883000,
       "url" => nil}]

```

For more information on archiving, see the
[OpenTok archiving](https://tokbox.com/opentok/tutorials/archiving/) programming guide.

# Documentation

Reference documentation for API Rest  is available at <https://tokbox.com/developer/rest/>.

# Requirements

You need an OpenTok API key and API secret, which you can obtain at <https://dashboard.tokbox.com>.

The ExOpenTok requires Elixir 1.2.

# Release Notes

See the [Releases](https://github.com/docjerem/ex_opentok/releases) page for details
about each release.

# Support

See <https://support.tokbox.com> for all our support options.

Find a bug? File it on the [Issues](https://github.com/docjerem/ex_opentok/issues) page. Hint:
test cases are really helpful!

defmodule OEmbed do
  @moduledoc """
  oEmbed consumer library for Elixir applications.

  > oEmbed is a format for allowing an embedded representation of a URL on third party sites. The simple API allows a website to display embedded content (such as photos or videos) when a user posts a link to that resource, without having to parse the resource directly.
  >
  > -- See [oembed.com](http://oembed.com) for more info about the protocol.

  This library supports any discoverable oEmbed endpoint and some other services via custom adapters.
  Among them:

    - Instagram
    - Pinterest

  ## Installation

  Add `oembed` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:oembed, "~> 0.1.0"}]
  end
  ```

  ## Usage

  ```elixir
  {:ok, result} = OEmbed.for("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
  ```
  """

  @core_providers [OEmbed.InstagramProvider,
                   OEmbed.PinterestProvider,
                   OEmbed.URProvider,
                   OEmbed.VimeoProvider,
                   OEmbed.YoutubeEmbedProvider,
                   OEmbed.DiscoverableProvider]

  @doc """
  Get oEmbed structure for given URL.

  ## Example

  ```elixir
  {:ok, result} = OEmbed.for("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
  ```
  """
  def for(_url = ""), do: {:error, "Empty URL"}
  def for(url) when is_binary(url) do
    case Enum.find(get_providers(), fn(provider) -> provider.provides?(url) end) do
      nil ->
        {:error, "oEmbed not found", :embed_not_found}
      provider ->
        provider.get(url)
    end
  end
  def for(_), do: {:error, "Empty URL"}

  defp get_providers do
    @core_providers
  end
end

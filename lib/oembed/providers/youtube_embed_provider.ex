defmodule OEmbed.YoutubeEmbedProvider do
  @moduledoc """
  oEmbed provider for Pinterest URLs.
  """
  use OEmbed.Provider

  @oembed_endpoint "https://www.youtube.com/oembed?format=json&url="

  @doc """
  Check if this provider supports given URL.
  """
  def provides?(url) do
    val = Regex.match?(~r/youtube\.com\/embed/im, url)
    IO.inspect val
    val
  end

  @doc """
  Get oEmbed result for given URL.
  """
  def get(url) do
    uri_data = URI.parse(url)
    video_id = String.split(Map.get(uri_data, :path), "/") |> List.last
    get_oembed(@oembed_endpoint <> URI.encode("https://youtube.com/watch?v=" <> video_id, &URI.char_unreserved?/1))
  end

end

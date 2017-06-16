defmodule OEmbed.VimeoProvider do
  @moduledoc """
  oEmbed provider for Pinterest URLs.
  """
  use OEmbed.Provider

  @oembed_endpoint "https://vimeo.com/api/oembed.format?url="


  @doc """
  Check if this provider supports given URL.
  """
  def provides?(url) do
    IO.puts url
    IO.puts Regex.match?(~r/vimeo/im, url)
    IO.puts "IMVOE!"
    Regex.match?(~r/vimeo/im, url)
  end

  @doc """
  Get oEmbed result for given URL.
  """
  def get(url) do
    get_oembed(@oembed_endpoint <> URI.encode(url, &URI.char_unreserved?/1))
  end

end

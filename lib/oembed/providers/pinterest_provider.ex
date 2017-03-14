defmodule OEmbed.PinterestProvider do
  @moduledoc """
  oEmbed provider for Pinterest URLs.
  """
  use OEmbed.Provider

  alias OEmbed.Rich

  @doc """
  Check if this provider supports given URL.
  """
  def provides?(url) do
    Regex.match?(~r/^(?:http|https):\/\/(?:[A-Za-z]+\.)?pinterest\.com\/[A-Za-z0-9-_\/]+/i, url)
  end

  @doc """
  Get oEmbed result for given URL.
  """
  def get(url) do
    html = case get_page_type(url) do
      _ -> get_pin_html(url)
    end

    IO.inspect get_page_type(url)

    oembed = Rich.new(%{
      html: html
    })

    {:ok, oembed}
  end

  defp get_page_type(url) do
    with {:ok, %HTTPoison.Response{body: html}} <- HTTPoison.get(url, [], [follow_redirect: true, ssl: [{:versions, [:'tlsv1.2']}]]),
      [_ | _] = tags <- Floki.find(html, "head meta[property='og:type']"),
       {"link", attributes, _} <- List.first(tags),
       %{"content" => content} <- Enum.into(attributes, %{}) do
        {:ok, content}
    else
      _ -> {:error, "Error getting page type"}
    end
  end

  defp get_pin_html(url) do
    """
      <a data-pin-do="embedPin" data-pin-width="large" href="#{url}"></a>
      <script async defer src="//assets.pinterest.com/js/pinit.js"></script>
    """
  end
end

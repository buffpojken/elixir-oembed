defmodule OEmbed.DiscoverableProvider do
  @moduledoc """
  oEmbed provider for discoverable endpoints.
  """

  use OEmbed.Provider

  @doc """
  Check if this provider supports given URL.
  """
  def provides?(_) do
    true
  end

  @doc """
  Get oEmbed result for given URL.
  """
  def get(url) do
    with {:ok, href} <- discover(url),
      {:ok, oembed} <- get_oembed(href) do
        {:ok, oembed}
    else
      _ ->
        {:error, "oEmbed not found", :embed_not_reached}
    end
  end

  defp discover(url) do
    with {:ok, %HTTPoison.Response{body: html}} <- HTTPoison.get(url, [], [follow_redirect: true, ssl: [{:versions, [:'tlsv1.2']}]]),
      [_ | _] = tags <- Floki.find(html, "head link[type='application/json+oembed'], head link[type='text/json+oembed']"),
       {"link", attributes, _} <- List.first(tags),
       %{"href" => href} <- Enum.into(attributes, %{}) do
        {:ok, href}
    else
      _ -> {:error, "oEmbed url not found", :embed_not_found}
    end
  end
end

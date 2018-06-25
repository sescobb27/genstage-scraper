defmodule ReqWithBackoff do
  # hakney :connect_timeout - timeout used when establishing a connection, in milliseconds
  # hakney :recv_timeout - timeout used when receiving from a connection, in milliseconds
  # poison :timeout - timeout to establish a connection, in milliseconds
  # :backoff_max - maximum backoff time, in milliseconds
  # :backoff_factor - a backoff factor to apply between attempts, in milliseconds
  def fetch(uri, headers \\ [], opts \\ []) do
    options =
      [
        follow_redirect: true,
        recv_timeout: Application.get_env(:arc, :recv_timeout, 5_000),
        connect_timeout: Application.get_env(:arc, :connect_timeout, 10_000),
        timeout: Application.get_env(:arc, :timeout, 10_000),
        max_retries: Application.get_env(:arc, :max_retries, 3),
        backoff_factor: Application.get_env(:arc, :backoff_factor, 1000),
        backoff_max: Application.get_env(:arc, :backoff_max, 30_000)
      ]
      |> Keyword.merge(opts)

    request(uri, headers, options)
  end

  defp request(uri, headers, options, tries \\ 0) do
    case HTTPoison.get(uri, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: _} = response} ->
        {:error, response}

      {:error, %HTTPoison.Error{reason: :timeout}} ->
        case retry(tries, options) do
          {:ok, :retry} -> request(uri, options, tries + 1)
          {:error, :out_of_tries} -> {:error, :timeout}
        end

      {:error, %HTTPoison.Error{reason: reason} = response} ->
        {:error, response}
    end
  end

  defp retry(tries, options) do
    cond do
      tries < options[:max_retries] ->
        backoff = round(options[:backoff_factor] * :math.pow(2, tries - 1))
        backoff = :erlang.min(backoff, options[:backoff_max])
        :timer.sleep(backoff)
        {:ok, :retry}

      true ->
        {:error, :out_of_tries}
    end
  end
end

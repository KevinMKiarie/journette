defmodule Journette.Cache do
  @moduledoc """
  Redis-backed cache via Redix. All operations degrade gracefully when
  Redis is unavailable — callers get nil/error instead of crashes.
  """
  require Logger

  @conn :journette_redis
  @default_ttl 300

  def get(key) do
    case Redix.command(@conn, ["GET", key]) do
      {:ok, nil} -> nil
      {:ok, value} -> Jason.decode!(value)
      {:error, reason} ->
        Logger.debug("[Cache] GET #{key} failed: #{inspect(reason)}")
        nil
    end
  rescue
    _ -> nil
  end

  def set(key, value, ttl \\ @default_ttl) do
    case Redix.command(@conn, ["SETEX", key, ttl, Jason.encode!(value)]) do
      {:ok, _} -> :ok
      {:error, reason} ->
        Logger.debug("[Cache] SET #{key} failed: #{inspect(reason)}")
        :error
    end
  rescue
    _ -> :error
  end

  def delete(key) do
    Redix.command(@conn, ["DEL", key])
    :ok
  rescue
    _ -> :ok
  end

  def increment(key, by \\ 1) do
    case Redix.command(@conn, ["INCRBY", key, by]) do
      {:ok, count} -> {:ok, count}
      {:error, _} -> {:error, :unavailable}
    end
  rescue
    _ -> {:error, :unavailable}
  end

  @doc """
  Fetch from cache; call `fun` on miss and populate cache.

  Usage:
      Cache.fetch("featured_articles", 300, fn -> Blog.get_featured() end)
  """
  def fetch(key, ttl \\ @default_ttl, fun) do
    case get(key) do
      nil ->
        value = fun.()
        set(key, value, ttl)
        value

      cached ->
        cached
    end
  end
end

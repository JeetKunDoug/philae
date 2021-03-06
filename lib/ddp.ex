defmodule Philae.DDP do
  use HTTPoison.Base
  alias Poison, as: JSON

  def handle(client_pid, msg) do
    {:ok, message} = JSON.decode(msg)
    handle_message(client_pid, message)
  end

  def handle_message(client_pid, %{"msg" => "ping"}) do
    send_json_message(client_pid, %{msg: "pong"})
  end

  def handle_message(client_pid, message) do
    IO.puts "I dont know what to with"
    IO.inspect message
  end

  def connect(client_pid) do
    send client_pid, {:send, connect_message}
  end

  defp connect_message do
    json!(%{msg: "connect", version: "1", support: ["1","pre2","pre1"]})
  end

  defp json!(map) do
    JSON.encode!(map) |> IO.iodata_to_binary
  end

  def send_json_message(client_pid, map) do
    send(client_pid, {:send, json!(map)})
  end
end

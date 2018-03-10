defmodule ElixirSocketTesting.Server do

  alias ElixirSocketTesting.ClientAgent
  
  def start(port \\ 9000) do
    # クライアント保持用のAgent
    ClientAgent.start_link

    # WebSocketサーバーリッスン
    server = Socket.Web.listen! port

    loop(server)
  end

  def loop(server) do

    # クライアントからの接続を待ち受ける
    client = server |> Socket.Web.accept!
    client |> Socket.Web.accept!

    # クライアントをAgentに追加
    ClientAgent.add(client)

    # 各クライアントからのメッセージは別プロセスで行う
    Task.async(fn -> recv(client) end)

    loop(server)
  end 

  def broadcast(packet) do
    # Agentに保持している全てのクライアントにメッセージを送信
    ClientAgent.all
    |> Enum.each(fn client -> Socket.Web.send(client, packet) end)
  end

  def recv(client) do
    # クライアントからのメッセージをハンドリング
    case client |> Socket.Web.recv! do
      {:text, message} -> 
        broadcast({:text, message})
        recv(client)
      {:close, _, _} -> ClientAgent.remove(client)
      other ->  IO.inspect other
    end
  end
end
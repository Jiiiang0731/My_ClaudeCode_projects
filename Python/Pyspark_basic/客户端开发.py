# 1. 创建socket对象
import socket
socket_client = socket.socket()
# 2. 连接到服务端
socket_client.connect(("localhost",8888))
# 3. 发送消息
while True:
    msg = input("请输入要给服务端发送的信息:")
    if msg == 'exit':
        break
    socket_client.send(msg.encode('utf-8'))
    # 4. 接收返回消息
    recv_data = socket_client.recv(1024)  #缓冲区大小  recv方法是阻塞的
    print(f"服务端回复的信息为:{recv_data.decode('utf-8')}")
    # 5. 关闭链接
socket_client.close()
# socket 简称套接字，是进程之间通讯的一个工具，好比现实生活中的插座，所有家用电器要想工作都是基于插座进行
# 进程之间想要进行网络通信需要socket

# socket 负责进程之间的网络数据传输 好比数据的搬运工

# 两个进程之间通过socket进行相互通讯 就必须有服务端和客户端
# socket服务端  等待其他进程的链接 可接受发来的消息 可以回复消息
# socket客户端  主动链接服务端 可以发送消息 可以接收回复
# 服务端可以同时接受多个客户端发来的消息

#创建socket对象
import socket
socket_server = socket.socket()

#绑定一个ip地址和端口  一个元组 (localhost , port)
socket_server.bind(('localhost',8888))

#监听端口
socket_server.listen(1)  # 1 表示允许连接的数量

#等待客户端连接
# result : tuple = socket_server.accept() # 返回的是一个二元元组
# conn = result[0]  #客户端和服务端的连接对象
# address = result[1]  #客户端的地址信息
# 也可以直接写成如下格式
conn,address = socket_server.accept()
#accept 是阻塞的方法 ，如果没有客户端连接就会一直卡在这里，不会继续运行
print(f"接收到了客户端的连接，客户端的信息是{address}")
while True:
    #接收客户端的信息   这里要使用的是客户端和服务端的本次链接对象 而不再是socket_server
    data : str = conn.recv(1024).decode('utf-8')  #最终获得的是一个字符串
    #recv 接受的对象是缓冲区的大小 一般1024即可
    #recv方法的返回值是也该字节数组 也就是bytes对象 不是字符串 可以通过decode方法通过utf-8编码，将字节数组转换为字符串对象
    print(f'客户端发来的消息 ：{data}')

    # 发送回复消息
    msg = input('请输入你要和客户端回复的消息:')
    if msg == 'exit':
        break
    # encode可以将字符串又变回字节数组
    conn.send(msg.encode('utf-8'))

# 关闭连接
conn.close()
socket_server.close()
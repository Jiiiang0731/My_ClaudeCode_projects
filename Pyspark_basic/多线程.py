#进程：一个程序，运行在系统之上，那么就称这个程序为一个运行程序，并分配进程id方便系统管理
#线程: 线程归属于进程，一个进程可以开启多个线程，执行不同的工作，是进程的实际工作的最小单位
#操作系统中可以有多个进程叫做多任务运行，一个进程中可以有多个线程叫做多线程运行
# 同一个操作系统中不同的进程的内存是隔离的，流氓软件除外
# 同一个进程内的所有线程是共享该进程的内存空间的

#并行执行： 同一时间做不同的工作
# 进程之间就是并行执行的，操作系统可以同时运行很多程序 这些程序都是并行执行的
# 线程也可以并行执行

# 多线程编程
#  threading
import threading
import time
def sing(msg):
    while True:
        print(msg)
        time.sleep(2)

def dance(msg):
    while True:
        print(msg)
        time.sleep(2)
if __name__ == '__main__':

    sing_thread = threading.Thread(target = sing,args = ('你挑着担，我牵着马，迎来日出，送别晚霞，踏平坎坷...',))
    dance_thread = threading.Thread(target = dance,kwargs = {"msg":"第七套全国中小学生广播体操，七彩阳光"})

    sing_thread.start()
    dance_thread.start()
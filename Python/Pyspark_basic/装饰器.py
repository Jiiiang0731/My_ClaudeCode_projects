# 装饰器就是一种闭包，其功能就是在不破坏目标函数原有的代码和功能的前提下，为目标函数新增新功能
# def sleep():
#     import random
#     import time
#     print('睡眠中')
#     time.sleep(random.randint(1,5))  #time.sleep()是一个整体功能
#
# def outer(func):
#     def inner():
#         nonlocal func
#         print('我要睡觉了')
#         func()
#         print("我起床了")
#     return inner
#
# fn = outer(sleep)
# fn()


def outer(func):
    def inner():
        nonlocal func
        print('我要睡觉了')
        func()
        print("我起床了")
    return inner


@outer  # 本质上还是在调用outer这个函数
def sleep():
    import random
    import time
    print('睡眠中')
    time.sleep(random.randint(1,5))  #time.sleep()是一个整体功能

sleep()
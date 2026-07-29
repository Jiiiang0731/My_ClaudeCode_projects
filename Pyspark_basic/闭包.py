# 在函数嵌套的前提下，内部函数使用了外部函数的变量，并且外部函数返回了内部函数，我们呢把这个使用外部
# 函数的变量的内部函数叫做闭包
# def outer(logo):
#     def inner(msg):  #这个内部函数就叫闭包
#         print(f'<{logo}><{msg}><{logo}>')
#     return inner
#
# fn1 = outer('黑马程序员')  #外层函数的变量会固定
# fn1('大家好啊')    #外部变量可以改变
# fn1('hello')
#
# fn2 = outer('itheima')
# fn2('James')
# fn2('Jiiiang')
#
# # 使用nonlocal 关键字修改外层函数的值
# def outer_1(num1):
#     def inner_1(num2):
#         nonlocal num1
#         num1 += num2
#         print(num1)
#     return inner_1
#
# fn3 = outer_1(10)
# fn3(10)
# fn3(10)
# fn3(10)
# fn3(10)
# fn3(-10)
        # def withdrawal(num1):
        #     nonlocal init_num
        #     init_num -= num1
        #     print(f'您当前的余额为{init_num}')
        #
        # return withdrawal


def atm(init_num):
    def deposit(num,deposit_msg = True):
        nonlocal init_num
        if deposit_msg:
            init_num += num
            print(f"您当前余额为{init_num}")
        else:
            init_num -= num
            print(f"您当前余额为{init_num}")
    return deposit

Atm = atm(100)
Atm(500)
Atm(300,False)
# 闭包的缺点 ： 内部函数持续引用外部函数的值，会导致这一部分的内存空间不被释放，一直被占用
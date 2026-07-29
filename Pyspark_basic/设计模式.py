# 设计模式是一种编程的套路 可以极大的方便程序的开发
# 最常见最经典的设计模式iu是面向对象的编程
# 除了面向对象外在编程中也有很多既定的套路可以方便开发 我们称之为设计模式
# 如 单例 工厂模式等
# 还有 制造者 责任链 状态 备忘录 解释器 访问者 观察者 中介 模板 代理模式等等

# 单例模式
# 一般地 用两个变量实例化类对象之后这两个不同的变量在电脑中的地址是不同的
# 如果可以实现无论多少变量实例化一个类对象时 他们的地址相同 就可以节省很多内存开销和节省创建类对象的开销
from Tooltest import str_tool
s1 = str_tool
s2 = str_tool
print(id(s1),id(s2))  #id 地址相同

# 工厂模式  常常在需要大量创建一个类的实例的时候使用
class Person:
    pass
class Worker(Person):
    pass
class Student(Person):
    pass
class Teacher(Person):
    pass
class PersonFactory:
    def get_person(self,p_type):
        if p_type == 'w':
            return Worker()
        elif p_type == "s":
            return Student()
        elif p_type == "t":
            return Teacher()

pf = PersonFactory()
worker = pf.get_person('w')
student = pf.get_person('s')
teacher = pf.get_person('t')
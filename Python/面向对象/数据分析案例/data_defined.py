"""
定义数据的类
"""
class Record:
    # date = None
    # order_id = None
    # money = None
    # province = None
    def __init__(self,date,id,money,province):
        self.date = date             #订单日期
        self.id = id     #订单编号
        self.money = money           #订单金额
        self.province = province     #订单省份

    def __str__(self):
        return f'{self.date},{self.id},{self.money:.0f},{self.province}'
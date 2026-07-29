"""
面向对象的数据分析案例 主业务萝莉代码

实现步骤如下
1 设计一个类 可以完成数据的封装
2 设计一个抽象类 定义问价读取的相关功能 并使用子类实现具体功能
（由于读取的文件类型可能不同 有可能是json也可能是csv所以用子类定义不同的格式的读取方式）
3 读取文件 生成数据对象
4 进行数据需求的逻辑计算 计算每一天的销售额
5 通过 pyecharts 进行图形的绘制
"""
from file_defined import TextFileReader,JsonFileReader
from data_defined import Record
from pyecharts.charts import Bar
from pyecharts.options import *
from pyecharts.globals import ThemeType
text_file_reader = TextFileReader(r"C:\Users\11586\Desktop\sales_january.txt")
json_file_reader = JsonFileReader(r"C:\Users\11586\Desktop\sales_february.json")

jan_data: list[Record] = text_file_reader.read_data()
feb_data: list[Record] = json_file_reader.read_data()
# 将两个月份的数据合并成一个list来存储
all_data : list[Record] = jan_data + feb_data

# 对数据进行计算
data_dict = {}
for data in all_data:
    if data.date in data_dict.keys():
        data_dict[data.date] += data.money
    else:
        data_dict[data.date] = data.money


#可视化图标开发
bar = Bar(
    init_opts=InitOpts(theme=ThemeType.DARK)
)
bar.add_xaxis(list((data_dict.keys())))   # 添加数据的时候需要列表格式
bar.add_yaxis("销售额",list(data_dict.values()),
              label_opts=LabelOpts(is_show=False)

              )
bar.set_global_opts(
    title_opts=TitleOpts(title="每日销售额")

)

bar.render("每日销售额柱状图.html")
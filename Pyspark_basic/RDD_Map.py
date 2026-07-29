# pyspark的数据计算都是基于RDD对象来进行的,依赖RDD对象内置的丰富的阿成员方法(算子)进行计算

# MAP 方法(算子)   将RDD内的数据一条一条地处理(基于map算子中接收的处理函数)，返回结果是一个新的RDD对象
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf = conf)

#准备一个rdd
rdd = sc.parallelize([1,2,3,4,5])

#通过map方法将全部的数据都乘以10
def func(data):
    return data * 10

# (T) -> U  代表我传入的函数应该满足可以传入一个参数 随后返回一个返回值
# (T) -> T  这种格式代表传入的参数格式应该和输出的返回值类型相同
rdd2= rdd.map(func)
rdd3 = rdd2.map(lambda x: x+5)
rdd4 = rdd3.map(lambda x: x+10).map(lambda x: x+15).map(lambda x: x+20)  # 链式调用
print(rdd4.collect())
sc.stop()
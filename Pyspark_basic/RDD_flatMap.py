# flatMap 对rdd执行map操作 然后进行解除嵌套的操作
# 接触嵌套 --> [[1,2,3],[4,5,6]] -> [1,2,3,4,5,6]
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf = conf)

# 准备一个rdd
rdd1 = sc.parallelize(["James to run","i am who i am","je viens de lyon"])
rdd2 = rdd1.flatMap(lambda x: x.split(' '))  # 解除嵌套
print(rdd2.collect())
sc.stop()
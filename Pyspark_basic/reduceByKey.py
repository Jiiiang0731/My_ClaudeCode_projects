#针对kv型的rdd数据 自动根据keys分组 然后根据开发者提供的聚合逻辑 完成组内数据(values)的聚合操作
# kv型的rdd -> 二元元组  ('a',1)  ('b',2)

#reduceByKey(func)
#func：(V,V) -> V  要求两个传入的参数和至少一个输出的参数 并且传入的两个参数和输出的一个参数的类型必须相同
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("Test_spark")
sc = SparkContext(conf = conf)

rdd = sc.parallelize([('男',99),('女',98),('男',96),('女',100),('男',98)])
rdd2 = rdd.reduceByKey(lambda a,b : a+b)
print(rdd2.collect())
sc.stop()
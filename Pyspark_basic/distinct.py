# 对rdd数据进行去重  返回新的rdd
#
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf = conf)

#准备一个rdd
rdd = sc.parallelize([1,1,1,2,2,3,3,3,4,4,5,5])
rdd1 = rdd.distinct()
print(rdd1.collect())
sc.stop()
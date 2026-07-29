# 过滤想要的数据进行保留
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("test_spark1")
sc = SparkContext(conf = conf)

#准备一个rdd
rdd = sc.parallelize([1,2,3,4,5])
# 对rdd数据进行过滤
rdd1 = rdd.filter(lambda num : num%2 == 0)
print(rdd1.collect())
sc.stop()
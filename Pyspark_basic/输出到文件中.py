from pyspark import SparkConf,SparkContext
import os

os.environ['HADOOP_HOME'] = "D:\\hadoop\\hadoop-3.3.6"
os.environ['PYSPARK_PYTHON'] = "C:\\ProgramData\\anaconda3\\python.exe"
conf = SparkConf().setMaster("local[1]").setAppName("test_spark")
# 创建的rdd分区可能会有很多个，其中一些可能根本没有内容跟，可以将分区设置为1
conf.set('spark.default.parallelism','1')
sc = SparkContext(conf = conf)

#saveAsTextFile算子   将rdd的数据写入文本文件中 支持本地写出 hdfs等文件系统
#依赖Hadoop
rdd = sc.parallelize([1,2,3,4])# 设置分区为1也可以在这里写成([1,2,3,4],numSlice* = 1)
rdd1 = sc.parallelize(['a','b','c','d'],1)
rdd2 = sc.parallelize([('a',1),('b',2)])
rdd3 = sc.parallelize([[1,2,3],[4,5,6]])

rdd .saveAsTextFile("D:\\output")
rdd1.saveAsTextFile("D:\\output1")
rdd2.saveAsTextFile("D:\\output2")
rdd3.saveAsTextFile("D:\\output3")



from pyspark import SparkConf,SparkContext
import os
# import json
os.environ['HADOOP_HOME'] = r"D:\hadoop\hadoop-3.3.6"
os.environ['PYSPARK_PYTHON'] = "C:\\ProgramData\\anaconda3\\python.exe"
# 创建spark对象
conf = SparkConf().setMaster('local[1]').setAppName('CASE_1')
conf.set("spark.default.parallelism","1")
sc = SparkContext(conf = conf)

# 创建rdd对象
rdd = sc.textFile(r"C:\Users\11586\Desktop\search_data.tsv")
rdd0 = rdd.map(lambda x : x.strip().split('\t'))
# 热门搜索时间段
rdd1 = (rdd0.map(lambda x : x[0][0:2])
        .map(lambda x : (x,1))
        .reduceByKey(lambda a,b : a+b)
        .sortBy(lambda x:x[1],ascending = False,numPartitions = 1).take(3))
print(f'热门搜索时间段Top3为{rdd1}[时间段，次数] \n')
# 热门关键词
rdd2 = (rdd0.map(lambda x :(x[2],1))
        .reduceByKey(lambda a,b : a+b)
        .sortBy(lambda x : x[1],ascending=False,numPartitions=1).take(3))
print(f'热门搜索关键词Top3为{rdd2}[关键词，次数] \n')
#黑马程序员出现次数排行
rdd3 = (rdd0.filter(lambda x : x[2] == '黑马程序员')
        .map(lambda x : (x[0][0:2],1))
        .reduceByKey(lambda a,b : a+b)
        .sortBy(lambda x : x[1],ascending=False,numPartitions=1).take(3))
print(f'黑马程序员热门出现时间段Top3为{rdd3}[时间段，次数]  \n')
# 文件转换为json并输出到文件
rdd.saveAsTextFile('D://CASE_1')
sc.stop()
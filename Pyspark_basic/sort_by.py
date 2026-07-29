# 对rdd数据进行排序 基于你指定的排序依据
# rdd.sortBy(func,ascending=bool,numPartitions=1)
# func是用来告知按照rdd中的哪一个数据进行排序，lambda x:x[1]指的是按照第二列的元素进行排序
# ascending = true 则升序排序  False则降序
# nunPartitions = 1 指的是用几个分区进行排序 在没有接触分布式之前先设为1
from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = "C:\\ProgramData\\anaconda3\\python.exe"
conf = SparkConf().setMaster("local[*]").setAppName('count_words')
sc = SparkContext(conf = conf)

rdd = sc. textFile(r"C:\Users\11586\Desktop\count_words.txt")
rdd1 = rdd.flatMap(lambda x:x.strip().split())
rdd2 = rdd1.map(lambda x:(x,1))
rdd3 = rdd2.reduceByKey(lambda a,b:a+b)

result_rdd = rdd3.sortBy(lambda x:x[1],ascending=True,numPartitions=1)
print(result_rdd.collect())
sc.stop()
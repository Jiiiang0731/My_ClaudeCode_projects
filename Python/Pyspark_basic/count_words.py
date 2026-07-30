from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = "C:\\ProgramData\\anaconda3\\python.exe"
conf = SparkConf().setMaster("local[*]").setAppName('count_words')
sc = SparkContext(conf = conf)

# 创建rdd对象
# words_list = []
# with open(r"C:\Users\11586\Desktop\count_words.txt",'r',encoding='utf-8') as f:
#     for line in f.readlines() :
#         words = line.strip().split()
#         words_list.extend(words)
rdd = sc. textFile(r"C:\Users\11586\Desktop\count_words.txt")
rdd1 = rdd.flatMap(lambda x:x.strip().split())
rdd2 = rdd1.map(lambda x:(x,1))
rdd3 = rdd2.reduceByKey(lambda a,b:a+b)
print(rdd3.collect())
sc.stop()
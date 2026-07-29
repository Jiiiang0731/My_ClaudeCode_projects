from pyspark import SparkConf,SparkContext
import os# import json
os.environ['HADOOP_HOME'] = r"D:\hadoop\hadoop-3.3.6"
os.environ['PYSPARK_PYTHON'] = "C:\\ProgramData\\anaconda3\\python.exe"
conf = SparkConf().setMaster('local[1]').setAppName('CASE_1')
sc = SparkContext(conf = conf)

rdd = sc.textFile(r"C:\Users\11586\Desktop\search_data.tsv")
print
# rdd2 = (rdd.map(lambda x :(x[2],1))
#         .reduceByKey(lambda a,b : a+b)
#         .sortBy(lambda x : x[1],ascending=False,numPartitions=1))
# print(f'热门搜索关键词为{rdd2.collect()}[关键词，次数] \n')


# with open("C:\Users\11586\Desktop\search_data.tsv",'r',encoding = 'utf-8') as f:
#     path: list = []
#     for line in f.readlines():
#         line_list = []
#         data = line.strip().split('\t')
#         line_list.extend(data)
#         path.append(line_list)




# text_fore = rdd.collect()
# text1 = json.dumps(text_fore,ensure_ascii = False,indent=2)
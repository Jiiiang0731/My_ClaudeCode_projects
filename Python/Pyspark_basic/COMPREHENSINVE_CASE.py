from pyspark import SparkContext,SparkConf
import os
import json
os.environ["PYSPARK_PYTHON"] = "C:\\ProgramData\\anaconda3\\python.exe"
conf = SparkConf().setMaster('local[1]').setAppName('comprehensive_case')
sc = SparkContext(conf = conf)

# 创建一个rdd
# rdd = sc.textFile("C:\\Users\\11586\Desktop\\comprehensive_case.txt")
# json_str_rdd = rdd.flatMap(lambda x : x.strip().split('|'))
# dict_str_rdd = json_str_rdd.map(lambda x: json.loads(x))
# print(dict_str_rdd.collect())

# 1.将文件当中的字典提取出来
with open("C:\\Users\\11586\\Desktop\\comprehensive_case.txt",'r',encoding='utf-8') as f:
    data_list = []
    for dict1 in f.readlines():
        dict2 = dict1.strip().split('|')
        data_list.extend(dict2)

rdd = sc.parallelize(data_list)
json_str_rdd= rdd.map(lambda x : json.loads(x))

# 2. 得到每一个字典数据中的城市和该城市的销售额
city_sale_data = json_str_rdd.map(lambda x: (x['areaName'],int(x['money'])))
# 3.分组聚合
city_sale = city_sale_data.reduceByKey(lambda a,b : a+b )
# 4. 排序
Best_city_sort = city_sale.sortBy(lambda x:x[1],ascending=False,numPartitions=1)
print(f"最佳城市销售额排行{Best_city_sort.collect()} \n")
# 5.有哪些商品类别在售卖
products = json_str_rdd.map(lambda x : x['category'])
products_simplify = products.distinct()
print(f"目前在全国范围内共有{products_simplify.collect()}进行售卖  \n")
# 6. 北京市有哪些商品在售卖
Peking = json_str_rdd.filter(lambda x: x['areaName'] == '北京').map(lambda x : x["category"]).distinct()
print(f"北京市目前有{Peking.collect()}进行售卖")
sc.stop()
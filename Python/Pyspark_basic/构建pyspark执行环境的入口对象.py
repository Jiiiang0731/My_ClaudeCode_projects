from pyspark import SparkConf,SparkContext

# 创建 SparkConf 对象
conf = SparkConf().setMaster("local[*]").setAppName("test_spark_app")  # 链式调用  规则: 无论调用多少个方法返回值必须是同一个对象

# 基于SparkConf类对象创建SparkContext对象
sc = SparkContext(conf = conf)


#RDD对象 Resilient Distributed Datasets 弹性分布式数据集
# rdd1 = sc.parallelize([1,2,3,4,5,6])
# rdd2 = sc.parallelize((1,2,3,4,5,6))
# rdd3 = sc.parallelize("James")
# rdd4 = sc.parallelize({1, 2, 3, 4, 5, 6})
# rdd5 = sc.parallelize({'name': 'James'})
# 如果要查看rdd的内容需要用collect()方法
# print(rdd1.collect())
# print(rdd2.collect())
# print(rdd3.collect())
# print(rdd4.collect())
# print(rdd5.collect())

# 读取本地文件构建rdd对象
rdd = sc.textFile(r"C:\Users\11586\Desktop\其他\sales_february.json")
print(rdd.collect())
sc.stop()

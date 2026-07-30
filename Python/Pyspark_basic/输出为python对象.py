from pyspark import SparkConf,SparkContext
import os
os.environ['PYSPARK_PYTHON'] = 'C:\\ProgramData\\anaconda3\\python.exe'
conf = SparkConf().setMaster("local[*]").setAppName("test_spark")
sc = SparkContext(conf = conf)


# collect算子  将rdd隔俄国分区内的数据 统一收集到driver中 形成并返回一个list对象
# rdd.collect()

# reduce算子 将rdd数据按照我们传入的逻辑进行两两聚合
rdd = sc.parallelize(range(1,10))
rdd1 = rdd.reduce(lambda a,b : a+b)
print(rdd1)

# take算子 取rdd的前n个元素组合成一个list返回
rdd3 = sc.parallelize([2,3,4,5,6,7,8,9])
print(rdd3.take(5))

# count算子  计算rdd中有多少条数据 返回一个数字
rdd4 = rdd3.count()
print(rdd4)

sc.stop()
"""
和文件相关的类定义
"""
from data_defined import Record
import json
# 定义一个顶层的抽象类来做顶层设计  确定有哪些功能
class FileReader:

    def read_data(self) -> list[Record]:
        """读取文件数据读到的每一条数据都转换为Record对象，将他们都封装到list类返回即可"""
        pass

class TextFileReader(FileReader):
    def __init__(self,path):
        self.path = path  # 定义成员变量 记录文件的路径

    #复写
    def read_data(self) -> list[Record]:
        f = open(self.path,"r",encoding= 'utf-8')
        lines = f.readlines()
        record_list:list[Record] = []
        for line in lines:
            Line = line.strip()  #消除读取的到的每一行数据中的/n
            data_list = line.split(',')
            record = Record(data_list[0],data_list[1],int(data_list[2]),data_list[3])
            record_list.append(record)
        f.close()

        return record_list


class JsonFileReader(FileReader):
    def __init__(self,path):
        self.path = path


    def read_data(self) -> list[Record]:
        with open(self.path,"r",encoding='utf-8') as f:
            root_list : list[Record] = json.load(f)
            record = []
            for date_dict in root_list:
                day_date = date_dict['date']
                provinces_list = date_dict['provinces']
                for province in provinces_list:
                    record_list = Record(
                        day_date,
                        province['id'],
                        float( province['money']),
                        province['province']
                    )
                    record.append(record_list)
        return record

if __name__ == '__main__':
    path = r"C:\Users\11586\Desktop\sales_january.txt"
    path1 = r"C:\Users\11586\Desktop\sales_february.json"
    text_file_reader = TextFileReader(path)
    json_file_reader = JsonFileReader(path1)
    list1 = text_file_reader.read_data()
    list2 = json_file_reader.read_data()

    for l in list1:
        print(l)

    for l in list2:
        print(l)


# 是方法（函数）自己调用自己的一种特殊的写法
import os
def a_test_os():
    print(os.listdir("D:\\recursion"))        # 可以将路径中的文件列出来
    print(os.path.isdir("D:\\recursion\\a"))  # 判断路径是否是文件夹 返回bool
    print(os.path.exists("D:\\recursion"))    # 判断路径是否存在

def get_files_recursion_from_dir(path):
    """
    从指定的文件夹中使用递归的方式获取全部的文件列表
    :param path: 被判断的文件夹
    :return: 包含全部的文件 如果目录不存咋或无文件就返回一个空的list
    """
    print(f'当前调用的文件是{path}')
    file_list = []
    if os.path.exists(path):
        for f in os.listdir(path):
            new_path = path + '\\' + f
            if os.path.isdir(new_path):
                file_list += get_files_recursion_from_dir(new_path)
            else:
                file_list.append(f)
    else:
        print(f"给定的路径{path}不存在")
        return []

    return file_list

if __name__ == '__main__':
    print(get_files_recursion_from_dir("D:\\recursion"))
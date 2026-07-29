# .   匹配所有字符
# \.  匹配点本身
# \d  匹配数字0-9
# \D  匹配所有非数字
# \s  匹配空白 即tab blank
# \S  匹配所有非空白
# \w  匹配所有单词字符 即a-z A-Z 0-9 _(注意这是下划线)
# \W  匹配所有非单词字符
# []  匹配[]中列举的特殊字符
# *   匹配前面的字符0次或多次
# +   匹配前面的字符1次或多次
# ?   匹配前面的字符0次或1次
# {n} 匹配前面的字符n次
# {n,} 匹配前面的字符n次或更多
# {n,m} 匹配前面的字符n到m次
# ^   匹配字符串的开始
# $   匹配字符串的结束
# |   匹配|左边或右边的字符
# ()  匹配括号内的字符
# \   转义字符
# \1  匹配第一个括号内的字符
# \2  匹配第二个括号内的字符


# result = re.findall(r'\d',s)
# result1 = re.findall(r'\w',s)
# result2 = re.findall(r'\W',s)
# result3 = re.findall('[a-zA_Z0-9]',s)  # 中括号中只能是a-zA-Z0-9这三个范围的组合，且没有逗号分开
# result4 = re.findall('[ace135]',s)
# print(result)
# print(result1)
# print(result2)
# print(result3)
# print(result4)


import re
# 匹配账号 只能由字母和数字组成 长度限制到6-10
while True:
    s = input('请创建你的账户名称')
    result = re.findall(r"^[a-zA-Z0-9]{6,10}$",s)
    list1 = [s]
    if result == list1:
        print('创建成功')
        break
    else:
        print('账号名称中必须只能包含字母和数字，长度必须在6-10位')

# 匹配qq号 只能纯数字 长度5-11 第一位不为0
while True:
    qq_num = input('请输入您的qq号')
    result1 = re.findall(r'^[1-9]\d{4,10}$',qq_num)
    list2 = [qq_num]
    if result1 == list2:
        print('创建成功')
        break
    else:
        print("qq号必须满足长度为5-11位 且首位不位0")

#匹配邮箱地址 只允许qq 163 gmail 三种邮箱地址
while True:
     mail_Address = input("请输入您的邮箱地址")
     result2 = re.findall(r'(^[\w-]+(\.[\w-]+)*@(qq|163|gmail)(\.[\w-]+)+$)',mail_Address)
     list3 = [mail_Address]
     if result2[0][0] == list3[0]:
         print("创建成功")
         break
     else:
         print('只允许qq 163 gmail 三种邮箱地址')

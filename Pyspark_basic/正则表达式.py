# 基础匹配
# 什么是正则表达式(规则表达式) 是使用单个字符串来描述、匹配某个雨打规则的字符串，常被用来
# 检索、替换哪些符合某个模式(规则)的文本

#Python正则表达式 使用re模块 并基于re中match search findall 三个基础方法来做正则匹配

#match 传入一个规则，match会跟据这个规则从字符串的第一个字符开始检索，若规则长度是n 则只检测[0,n]这n个字符
# 如果这前n个字符不满足 那么后续不再进行检索 返回None
import re
s = 'itheima python'
s1 = '1itheima python'
result = re.match('itheima',s)
result1 = re.match('itheima',s1)
# print(result)
# print(result1)
# print(result.span())   # 规则字符串长度
# print(result.group())  # 规则字符串

# search 搜索整个字符串，找出匹配的 从前到后 找到第一个之后就停止 不再继续检索
s2 = 'itheima python itcast James Jiiiang who i am itcast'
s3 = 'hahahahahah'
result2 = re.search('itcast',s2)
result3 = re.search('itcast',s3)
print(result2)
print(result3)
print(result2.span())
print(result2.group())

# findall 搜索整个字符串，找出所有匹配的 返回的东西是一个list 没有找到成功匹配的对象会返回一个空列表
s4 = 'itheima itcast python James itcast itcast'
s5 = 'so i will help Mr.li to take this course for your guys'
result4 : list = re.findall('itcast',s4)
result5 : list = re.findall('itcast',s5)
print(result4)
print(result5)
num = 0
for item in result4:
    num += 1
print(f'共有{num}个"itcast"')

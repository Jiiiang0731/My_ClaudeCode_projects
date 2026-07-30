-- select all/distinct 
-- 目标列表达式 别名
-- 目标列表达式 别名...
-- FROM 表名 别名，表名 别名...
-- where 条件表达式
-- group by 列名
-- having 条件表达式
-- order by 列名 asc/DESC
-- limit 数字或列表

-- 创建数据库和表
create table mydb1.instance11 (
id int primary key auto_increment,
name varchar(20),
price double ,
category_id varchar(20)
);
insert into instance11 VALUES
(null,'Washer',5000,'c001'),
(null,'refrigerator',300,'c002'),
(null,'air_conditoner',3000,'c003'),
(null,'rice_cooker',1000,'c004');
update instance11 set price = 3000 where category_id = 'c002';
rename table instance11 to example ;
insert into example values
(null,'jeans',500,'c005'),
(null,'jacket',500,'c006'),
(null,'shirts',300,'c007'),
(null,'chinos',200,'c008'),
(null,'SK-II',1000,'c009'),
(null,'facial_cream',200,'c010'),
(null,'perfume',300,'c011'),
(null,'foundation',200,'c012'),
(null,'instant_noodles',20,'c013'),
(null,'nut',30,'c014');


-- 1.查询所有商品
select * from example;
select id,name,price,category_id from example;
-- 2.查询商品名和商品价格
select name,price from example ;
-- 3.别名查询 使用关键字as
-- 3.1表别名
select * from example as p; -- as可以省略
select * from example  p; -- 在多表查询中使用的更多
-- 3.2列别名
select name as n ,price as p from example;
-- 4.去掉重复值
select distinct price from example ;
select distinct * from example;  -- 排除某两行的数据完全相同的情况
-- 5. 查询结果是表达式(运算查询)：将所有商品都加价10元进行显示
select name,price+10 from example;


-- 运算符  
-- 在数据库中的表结构确立以后 表中的数据的意义就已经确定。通过mysql的运算符进行运算，就可以获取到表结构以外的另一种数据。
-- 1.算数运算符
-- + 加法
-- - 减法 
-- * 乘法 
-- /或div 除法运算返回商  
-- %或mod 求余运算返回余数
select 6+2;
select 6-2;
select 6*2;
select 6/2;
select 6 div 2;
select 6 % 2;
select 6 mod 2;
-- 将所有商品的价格上调10%
select name,price * 1.1 as new_price from example ;


-- 2. 比较运算符
-- 3. 逻辑运算符
-- 求最大最小值
select least (10,20,30);
select least (10,20,null); -- 在最大最小值的判断中有null时均为null
select greatest(10,20,30);
select greatest(10,20,null);
-- 查询商品名称为washer的所有信息
select * from example where name = 'washer';
-- 查询价格为200的所有商品
select * from example where price = 200;
-- 查询价格不是200的所有商品
select * from example where price <> 200;  -- != 也可以写成 <>
select * from example where price != 200;
select * from example where not (price = 200);
-- 查询价格大于2000的商品
select * from example where price > 2000;
-- 查询商品价格在200- 2000的商品
select * from example where price between 200 and 2000; -- 包含上下界
-- and/&&表示 同时 满足
select * from example where price >= 200 and price <= 1000;
select * from example where price >= 200 && price <= 1000;
-- 查询商品价格是200 或者 3000的所有商品
select * from example where price in (200,3000); -- in后面的是列表
select * from example where price = 200 or price = 3000;
select * from example where price = 200 || price = 3000;
-- 查询含有字母'r'的所有商品
-- %用于匹配任意字符 模糊匹配
select * from example where name like '%r'; -- '%x'表示以x为结尾的所有元素
select * from example where name like '%r%';-- '%r%'表示包含r都算
select * from example where name LIKE 'w%'; -- 'x%'表示以x开头 
-- 查询第二个字母为i的商品
-- _表示匹配单个字符
select * from example where name like '_i%';-- 前俩个字符
-- 查询category_id为null的商品
select * from example where category_id is null;
select * from example where category_id is not null;




-- 4.位运算符
-- 位与
select 3 & 5 ;
-- 0011  -> 3
-- 0101  -> 5
-- ----  只要有一个为0那么位与后就是0  必须两个都是1 位与后才是1
-- 0001  -> 1

-- 位或
select 3 | 5;
-- 0011
-- 0101
-- ---- 只要有一个为一 位或后的值就是1
-- 0111  -> 7

-- 位异或
select 3 ^ 5;
-- 0011
-- 0101
-- ---- 两个数 相同为0 不同为1
-- 0110  -> 6

-- 位左移
select 3<<1;
0011 --> 0110 
-- 位右移
select 3>>1; 
0011 --> 0001

-- 位取反
select ~3 ;
0000...0011  --->  1111...1100 (32位)



-- 5.排序查询
-- 1. 使用价格查询(降序)
select * from example order by price ; -- 默认升序
select * from example order by price asc;
select * from example order by price desc; -- 降序
-- 2.在价格排序的基础上以分类排序
select * from example order by price desc,category_id desc;
-- 当price相同时才按category_id进行降序排序 价格不同时category_id没用
-- 3. 显示商品的价格(去重) 并排序
select distinct price from example  order by price desc;


-- 6.聚合查询
-- 6.1 count() 统计某一类不为null的记录行数
-- 查询商品的总条目
select count(id) from example;
select count(*) from example; -- 总共有多少行 整行全空也会计数
-- 查询价格大于1000的商品的总数
select count(id) from example where price > 1000;
-- 查询分类为c001的商品的总数
select count(id) from example where category_id = 'c001';
-- 6.2 sum() 计算指定列的数值和,如果指定列不是数值类型 那么计算结果为0
-- 查询分类为c001的商品的价格总和
select sum(price) from example where category_id = 'c001';
-- 6.3 max() 计算指定列的最大值,如果指定列时字符串类型 那么使用字符串排序
-- 查询商品的最大价格
select max(price) from example ;
-- 6.4 min() 计算指定列的最小值,如果指定列时字符串类型 那么使用字符串排序
select min(price) from example ;
-- together
select max(price) as max_price , min(price) as min_price from example;
-- 6.5 avg() 计算指定列的平均值,如果指定列不是数值类型 那么计算结果为0
select avg(price) from example where category_id in ('c001','c002','c004');
-- 6.6 对null的处理
create table example2 (
c1 VARCHAR(20),
c2 INT
);
alter table example2 change c2 c2 int default 0;
update example2 set c2 = 0 where c2 is  NULL;
insert into example2 values
('aaa',3),
('bbb',3),
('ccc',NULL),
('ddd',6);
select count(*),count(1),count(c2) from example2; -- count(c2)不算null
select sum(c2),max(c2),min(c2),avg(c2) from example2;



-- 7.分组查询
update example set category_id = 'c001' where id in (1,2,3,4);
update example set category_id = 'c002' where id in (5,6,7,8);
update example set category_id = 'c003' where id in (9,10,11,12);
update example set category_id = 'c004' where id in (13,14);
select count(1) from example group by category_id ;
select sum(price) from example group by category_id;
select avg(price) from example group by category_id;
select category_id,avg(price) from example group by category_id;
select category_id ,count(id) from example group by category_id;
-- group by后面可以跟多个字段
select id,name from atable GROUP BY province,city,country; -- assumption

-- having 在分组之后载进行筛选 作用和where差不多 但是分组后不可以用where
select category_id,count(*) from example group by category_id having count(*)>=4;
select category_id,count(1) cnt from example group by category_id having cnt=2;
-- SQL的执行顺序
-- from -->where --> group by --> having -->select --> ORDER BY 


-- 8.分页查询
-- 8.1 查询example表前5条数据
select * from example limit 5;
-- 8.2 从第4条开始显示5条
select * from example limit 3,5;
-- 分页显示
select * from example limit (n-1)*60,60;


-- insert_into_select 语句
use mydb1;
create table product(
name varchar(20),
price double 
);
insert into product(name,price) select name,price from example;
create table product1(
category_Id varchar(20) ,
product_count INT
);
insert into product1 select category_id,count(1) from example group by category_id;





-- exercise 
use mydb1;
create table mydb1.exercise(
id int primary key auto_increment,
name varchar(20),
gender varchar(20),
chinese int,
english INT,
math INT
);
alter table exercise auto_increment = 1001;
drop table exercise;
insert into exercise values
(null,'James','male',124,136,117),
(null,'Marry','female',110,124,110),
(null,'Tony','male',111,122,130),
(null,'Mario','female',130,120,120),
(null,'Tom','male',129,127,123),
(null,'Jerry','female',120,129,139),
(1007,'Furbery','male',129,110,110);
insert into exercise values
(1007,'Furbery','male',129,110,110);
alter table exercise change id id int;
alter table exercise drop primary key;
-- 查询表中所有学生的信息
select * from exercise ;
-- 查询表中所有学生的姓名和对应的英语成绩
select name,english from exercise;
-- 过滤表中的重复信息
select distinct * from exercise;
-- 统计每个学生的总分
alter table exercise add total_score double;
update exercise set total_score = chinese + english + math;
select name,total_score from exercise;
-- 在所有学生总分的基础上加10分的特长分
select name,total_score + 10 from exercise;
-- 使用别名表示学生的分数
select name,total_score as ts from exercise;
-- 查询英语成绩大于90分的同学
update exercise set english = 89 where name = 'Jerry';
select name,english from exercise where english >= 90;
-- 查询总分大于370的同学
select name,total_score from exercise where total_score >= 370;
-- 查询英语分数在100-120之间的同学
select name,english from exercise where english between 100 and 120;
-- 查询英语分数不在100-120分之间的同学
select name,english from exercise where english not between 100 and 120;
-- 查询数学分数为110,120,130的同学
select name,math from exercise where math in (110,120,130);
-- 查询所有姓名首字母为T的同学的语文成绩
select name,chinese from exercise where name like 'T%';
select name,total_score from exercise where name like '%r%';
-- 查询英语大于130分或总分大于370的同学
select name,english,total_score from exercise where english > 130 || total_score > 370;
update exercise set total_score =  348 where name = 'Jerry';
-- 对数学成绩降序排序后输出
select name,math from exercise order by math desc;
-- 对总分进行排序后输出 再按从高到低的顺序输出
select name,total_score from exercise;
select name,total_score from exercise order by total_score desc;
-- 对姓名首字母为T的同学的总分进行从高到低排序后输出
select name,total_score from exercise where name like 'T%' order by total_score desc;
-- 查询男生和女生分别有多少人 并将人数降序排序输出
select gender,count(1) as cot from exercise group by gender order by cot desc;



-- exercise1
create table exercise1 (
eid int,
ename varchar(20),
job varchar(50),
mgr int,
hiredate date,
sal INT,
commission int,
deptno int
);
insert into exercise1 values
(7369,'Smith','clerk',7902,'1980-12-17',800,null,20),
(7499,'Allen','salesman',7698,'1981-02-20',1600,300,30),
(7521,'Ward','salesman',7698,'1981-02-22',1250,500,30),
(7566,'Jones','manager',7839,'1981-04-02',2975,null,20),
(7654,'Martin','salesman',7698,'1981-09-28',1250,1400,30),
(7698,'Blake','manager',7839,'1981-05-01',2850,null,30),
(7782,'Clart','manager',7839,'1981-06-09',2450,null,30),
(7788,'Soctt','analyst',7566,'1987-04-19',3000,null,10),
(7839,'King','president',null,'1981-11-27',5000,null,20),
(7844,'Turner','salesman',7698,'1981-09-08',1500,null,30),
(7876,'Adams','clerk',7788,'1987-05-20',1100,null,20),
(7900,'James','cler',7698,'1981-07-31',950,null,30),
(7902,'Ford','analyst',7566,'1981-12-03',3000,null,20),
(7934,'Miller','clerk',7728,'1981-01-23',1300,null,10);
-- 按员工编号升序排列不在10号工作部门的员工信息
select * from exercise1 where deptno = 10 order by eid asc;
-- 查询姓名第二个字母不是a且薪水大于1000元的员工信息 按年薪降序排列
update exercise1 set commission = 0 where eid = 7844;
-- ifnull(x,n)  如果x是null 那么x赋值为0
select ename,job,(sal * 12 + ifnull(commission,0))  as YS from exercise1 where sal > 1000 and ename not like '_a%' order by YS DESC; 
-- 求每个部门的平均薪资
select avg(sal),deptno as avs from exercise1 group by deptno order by avs desc;
-- 求每个部门的最高薪水
select ename,max(sal) as ms,deptno from exercise1 group by deptno order by deptno desc;
-- 求每个部门每个岗位的最高薪水
select deptno,job,max(sal) as ms from exercise1 group by deptno,job order by deptno;
-- 求平均薪资大于2000的部门编号
select deptno,avg(sal) as avs from exercise1 group by deptno having avs > 2000 order by avs desc;
-- 将部门平均薪水大于1500的部门编号列出来,按部门平均薪资降序排序
select deptno,avg(sal) as avs from exercise1 group by deptno having avs > 1500 order by avs desc;
-- 选择公司中有奖金的员工的姓名,工资
select ename,sal,commission from exercise1 where commission is not NULL order by sal desc;
-- 查询员工最高工资和最低工资的差距
select max(sal),min(sal),max(sal)- min(sal) as gap from exercise1 ;


-- 正则表达式 regexp(REGULAR EXPRESSION)
-- ^ 匹配输入字符串的开始位置
select 'abc' regexp '^a'; -- 1 means True
select * from exercise1 where ename regexp '^J';
-- $ 匹配输入字符串的结束位置
select 'abcd' regexp 'c$';
select * from exercise1 where ename regexp 's$'
-- . 表示除了/n之外的 任意 一个字符
select 'abc' regexp '.c';
select 'abc' regexp 'a.';
select 'abc' regexp '.b';
-- [...] 字符集合  匹配所包含的 任意 一个字符 如[abc]可以匹配plain中的a
select 'abc' regexp '[xyz]';
select 'abc' regexp '[xyc]';
-- [^...] 负字符集合 匹配未包含的 任意 一个字符 如[^abc] 可以匹配plain中的p
select 'abc' regexp '[^bc]'; -- ^只有在[]内才表示取反
select 'x' regexp '[^abc]';
select 'abc' regexp '[^a]'; -- 只要含有不是a的字符都是1
-- * 匹配*前面那个表达式0次或多次
select 'stab' regexp 'a*';
select 'stb' regexp 'a*';
-- + 匹配+前面那个表达式1次或多次
select 'stab' regexp 'a+';
select 'stb' REGEXP 'a+';
-- a? 匹配0或1个a
select 'stab' REGEXP 'a?';
select 'stn' regexp 'a?';
select 'aaa建材王哥' regexp '^a?$';
select 'staab' regexp '.ta?b';
-- p1|p2|p3匹配p1,p2或p3
-- 例如Z|food可以匹配z或food,(z|f)ood可以匹配zood,food
-- a|b 匹配a或b
select 'ab' regexp 'a|b';
select 'abc' regexp 'a|b';
select 'a' regexp 'a|b';
select 'ca' regexp '^(a|b)';
select * from exercise1 where ename regexp '^(J|M|s)';
-- {n} n是一个非负整数 匹配 确定 的n次,o{2}不能匹配boy,但是可以匹配food
select 'Jmmmma' regexp 'm{4}';
select 'Tmmma' regexp 'm{5}';
-- {n,m} n,m均为非负整数 其中n<=m 最少匹配n次最多匹配m次
select 'Ymmmma' regexp 'ym{2,3}a';
-- (abc) ()中的值作为一个整体匹配,不用括号阔起来的都是用单个字符进行匹配,如果需要把多个字符当作一个整体匹配就需要用到括号,比如说在匹配给定的邮箱格式时,@163就可以作为一个整体进行匹配.在python中findall函数在处理括号时,会将括号中的值作为一个元素返回在result的元素当中,如果要whileTrue循环确定给定值符合要求,可以在整个正则表达式外围再加上一个括号,result的0号元素即为完整字符串
select 'sbabybabyt' regexp 's(baby){1,}t';
create database mydb7;
use mydb7;

-- 索引就是通过某种算法  
-- 构建出一个数据模型 用于快速在庞大的数据中快速找寻某条具体的数据,不然就要依次搜寻
-- 类似于英文词典查询单词的过程,通过索引可以节省大量的时间和资源

-- 索引是存储引擎用来快速查找记录的一种数据结构 按实现的方式类分 主要有Hash和B+Tree


-- 单列索引 一个索引只包含单个列  但一个表中可以有多个单列索引
-- 1. 普通索引  MySQL中的基本索引类型 没有什么限制 允许在定义索引的列中插入重复值和空值  纯粹为了查询数据更快一点
-- 创建方式1 : 在创建表的时候直接添加索引
drop table if exists student;
create table student(
sid int primary key ,
card_id varchar(20),
name varchar(20),
gender varchar(20),
age int ,
birth date,
phone_num varchar(20),
score double ,
index index_name(name)  -- 给name这个列创建索引
);
insert into student values(1001,'510502','James','male',19,'2007-07-31','19161567045',150);
select * from student where name = '张三';

-- 方式2 : 直接创建
create index index_gender on student(gender);
create index index_name on student(name);
-- 方式3 : 修改表的结构来添加索引
alter table student add index index_age(age);

-- 查看表中的所有索引
select * from mysql.innodb_index_stats a where a.database_name = 'mydb7'
and a.table_name like '%student%';
   
show index from student;

-- 删除索引

 drop index index_name on student ;

alter table student drop index index_name;



-- 2. 唯一索引 : 要求索引列的值必须唯一  但允许有null 
--               如果是组合索引 那么列值的组合必须唯一
-- 方式1 在创建表的时候指定唯一索引
create table student2(
sid int primary key ,
card_id VARCHAR(20),
name varchar(20),
gender varchar(20),
age int,
birth date ,
phone_num varchar(20),
score double ,
unique index_card_id(card_id)
);

-- 方式2 : 直接创建
create unique index index_sid on student2(sid);

-- 方式3 : 修改表结构 添加索引
alter table student2 add unique index_phone_num(phone_num);

drop index index_sid on student2;
alter table student2 drop index index_phone_num;


-- 3. 主键索引  主键索引是在确认table主键时自动给主键列添加的主键索引 规定主键列不能为null且不能重复  所以主键索引是一种特殊的唯一索引
-- 主键索引只能用show语句检索  在设计表中不能查看主键索引
show index from student2;


-- 组合索引  也叫复合索引 指的是我们在建立索引的时候使用多个字段  例如同时使用身份证号和手机号建立索引 同样的可以建立为普通索引或者唯一索引  复合索引的使用符合最左原则
-- 最左原则的意思是组合索引会从左到右依次来对创建的索引进行检索比对,不能跳过某一个直接检索右边的索引
-- 比如下述语法中可以单独索引column1 但是不能单独索引column2 ,两个同时索引时顺序不影响执行,sql会自动优化

-- 创建索引的基本语法
-- create index indexname on table_name(column1(length),column2(length));
create index index_name on student(card_id,phone_num);

select * from student where phone_num = '19161567045'; -- error
select * from student where card_id = '510502';
select * from student where phone_num = '19161567045' and card_id = '510502';
select * from student where card_id = '510502' and phone_num = '19161567045';
select * from student where card_id = '510502'or phone_num = '19161567045';
select * from student where phone_num = '19161567045'or card_id = '510502';



-- 全文索引 fulltext
-- 全文索引主要是用来查找文本中的关键字的  而不是直接与索引中的值相比较  全文索引更像是一个搜索引擎  基于相似度的查询  而不是简单的where匹配
-- 在数据量巨大的情况下用like % 的模糊匹配是非常不明智的  此时使用全文索引的速度会比普通的like %快上非常多
select * from student where card_id like '%105%';

-- 注意事项 只有类型为char varchar date及其系列才可以建立全文索引
-- 在数据量较大的时候,先将数据放入一个没有全局索引的表中 然后再用create index创建fulltext索引要比先为一张表建立fulltext然后再写入数据的速度更快
show variables like '%ft%';
drop table if exists t_article;
create table t_article (
 id int primary key auto_increment ,
 title varchar(255),
 content varchar(1000),
 writing_date date
);

insert into t_article values
(null,"Yesterday Once More","When I was young I listen to the radio",'2021-01-01'),
(null,"Right Here Waiting","Oceans apart, day after day,and I slowly go insane",'2021-10-02'),
(null,"My Heart Will Go On","every night in my dreams,i see you, i feel you",'2021-10-03'),
(null,"Everything I Do","look into my eyes,You will see what you mean to me",'2021-10-04'),
(null,"Called To Say I Love You","say love you no new year's day, to celebrate",'2021-10-05'),
(null,"Nothing's Gonna Change My Love For You","if i had to live my life without you near me",'2021-10-06'),
(null,"Everybody","We're gonna bring the flavor show U how.",'2021-10-07');


alter table t_article add fulltext index_content(content);

select * from t_article where match(content) against('yo');  -- 不够最小搜索长度3
select * from t_article where match(content) against('you');




-- 空间索引  是对空间数据类型的字段建立的索引 MYSQL中的空间数据类型有四种 geometry,point,linestring,polygon
-- MYSQL使用SPACIAL关键字进行扩展  使得能够用于创建正规索引类型的语法创建空间索引
-- 创建空间索引的列 必须将其声明为NOT NULL
create table shop_info(
id int primary key auto_increment comment 'id',
shop_name varchar(64) not null comment '门店名称',
geom_point geometry not null comment '经纬度',
spatial key geom_index(geom_point)
);


-- 索引的使用原则
-- 1. 更新频繁的列不应设置索引
-- 2. 数据量少的表不要使用索引
-- 3. 重复数据多的字段不应设置为索引 比如性别年龄等 重复数据超过15%就不适合设置索引
-- 4. 首先应该考虑对where 和 order by 涉及的列上建立索引

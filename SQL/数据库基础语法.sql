-- 1. 创建数据库
create database if not exists mydb1;

-- 2. 选择 用哪一个数据库
use mydb1;

-- 3. 删除数据库
-- drop database mydb1;
drop database if exists mydb2;

-- 4. 修改数据库编码 默认是utf8 不用修改
alter database mydb1 character set utf8;

-- 5. 在数据库中创建表
use mydb1;
create table if not exists student(
  id int,
  name varchar(20),  -- 'name'
  gender varchar(3),
--   int默认是带符号的 无符号加上unsigned
  age INT unsigned,  
  birth date, -- YYYY-MM-DD  2007-07-31
  address varchar(50)
);

--  6. 修改表 添加某些列
alter table student add score int;
-- decimal(m,n)  m表示有效位数，n表示保留n位小数
alter table student add gpa decimal(10,3) after address; 
alter table student change id sid int not NULL;
alter table student drop column address;   -- column 可以不要
alter table student ADD dept VARCHAR(20);

-- 7. 对表结构的其他操作
--  查看当前数据库的所有表的名称
show tables;
--  查看指定某个表的创建语句
show create table stu;
-- CREATE TABLE `stu` (
--   `sid` int NOT NULL,
--   `name` varchar(20) DEFAULT NULL,
--   `gender` varchar(3) DEFAULT NULL,
--   `age` int unsigned DEFAULT NULL,
--   `birth` date DEFAULT NULL,
--   `gpa` decimal(10,3) DEFAULT NULL,
--   `score` int DEFAULT NULL,
--   `dept` varchar(20) DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3
--  查看表结构 
desc student;
--  8.删除表 drop table 表名

-- 9.重命名表名
rename table student to stu;

--  10.数据插入
insert into stu values 
(9527,'Tony','男',46,'1980-06-18',3.11,88,'地球物理'),
(1431,'James','男',19,'2007-07-31',3.43,94,'数据科学'),
(2345,'Zhorlin','女',19,'2007-01-16',3.66,90,'物理学'),
(5738,'Linda','女',38,'1988-10-10',3.88,98,'金融学'),
(9739,'Marry','女',26,'2000-01-05',3.13,89,'英语');
insert into student values (9745,'John','男',19,'2007-04-17',2.99,76,'医学');
alter table student change gpa gpa decimal(10,2) not null;

-- 11.修改数据
rename table stu to student;
update student set gpa = 3.78,score = 96 where sid = 5738;
update STudent set score = score + 5 where sid = 1431;
 -- 不写where条件就是默认该列所有数据全部修改
 
--  12. 删除数据
insert into student(sid,gpa) values (1001,2); 
delete from student where sid = 1001;
--  不写where 默认全部删除

--  13. 清空表数据
truncate table stu;
 -- truncate的作用是删除整个表 类似drop table，但truncate会在删除后创建一个含有相同列数据的新表
 
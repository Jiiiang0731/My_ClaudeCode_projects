use mydb8;

-- 查询当前数据库支持的存储引擎
show engines;

-- 查看当前的默认存储引擎
show variables like '%storage_engine%';

-- 查看某个表用了什么引擎(在显示结果里参数engine后面的就表示当前用的)
show create table student;

-- 创建新表时指定存储引擎
drop table if exists student;
create table mydb8.student(
id int primary key,
name varchar(20),
grade double 
) engine = InnoDB;

create table student2(
id int primary key,
name varchar(20),
grade double 
) engine = Myisam;
show create table student2;

-- 修改数据库的存储引擎
alter table student engine = Myisam;  -- 不支持事务和外键
alter table student engine = InnoDB;


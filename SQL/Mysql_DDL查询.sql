-- constraint 约束实际上就是表中的数据的限制条件
-- 表在设计的时候加入约束的目的就是为了保证表中的记录完整性和有效型 比如用户表有些列的值非空 有些值不能重复等
use mydb1;



-- 1. 主键约束   primary key 
-- 写法1
create table instance (
  eid int primary key, -- 一定要有代表性 可以唯一确定某一列
  name varchar(20),
  dept varchar(20),
  salary double 
);

-- 写法2
create table instance1(
id int,
name varchar(20),
salary double ,
dept varchar(20),
constraint pk1 primary key(id)  -- constaint pk1 可以省略
);
-- 主键作用
insert into instance values 
(1001,'James','datascience',20000);
insert into instance values 
(1002,'Marry','datascience',15000);
insert into instance values
(null,'Tom','datascience',8000); -- cannot be null 主键约束的列唯一且非空
-- 查看某个表的内容
select * from instance where salary >= 20000;

--  联合主键 不能在字段之后声明主键约束 一张表只能有一个主键 联合主键也算作一个主键
create table instance2 (
name VARCHAR(20),
eid INT,
salary double,
constraint pk2 primary key(name,eid)
);

insert into instance2 values
('James',1001,20000),
('marry',1002,15000);
insert into instance2 values('Marria',1003,13000);
insert into instance2 values('Marry',1004,15000); -- 联合主键只要不是完全相同都不算重复
insert into instance2 values('Tony',NUll,17000);   -- 联合主键不能有任意一个为空

-- 修改表格结构时添加主键
create table instance3 (
name VARCHAR(20),
eid INT,
salary double 
);
alter table mydb1.instance3 add primary key (name,eid);

-- 删除主键约束 
alter table instance3 drop primary key ; -- 不用指定，主键只有一个，不论联合否





-- 2. 自增长约束 auto_increment
-- 当主键定义为自增长后 这个主键就不需要用户输入，该列值会根据数据库的定义自动赋值     每增加一条记录 主键会自动以相同的步长进行增长 
create table instance4 (
name VARCHAR(20),
eid int primary key auto_increment, -- 在一个表内只能有一个字段自增长 且必须是主键
salary double
-- auto_increment = 100 可以在这个位置指定自增长的起始值
);
insert into instance4 values('James',NULL,20000);
insert into instance4 values('Marry',NULL,12000);
-- 自定义自增长的起始值
alter table instance4 auto_increment = 100;
insert into instance4 values('Mario',NULL,18000);
-- delete删除数据后自增长会从删除前的最后一条数据开始接着往后  truncate则从1开始
delete FROM instance4;
truncate instance4;





-- 3. 非空约束   not null  限定不能为空 
create table instance5 (
id INT, 
name varchar(20) not NULL,
address varchar(20) not NULL
);
alter table instance5 modify id int not NULL; -- 设定为非空
alter table instance5 modify id int ; -- 恢复可空
insert into instance5 values (101,'James','WuHan');
desc instance5 ; -- 查看表的结构





-- 4. 唯一性约束 unique 
-- 给某一个字段加上唯一性约束后 这一列的值就必须是唯一的不能重复
create table instance6 (
id int unique,
name varchar(20),
phone_num int unique
);
insert into instance6 values(0731,'James',7045);
insert into instance6 values(0732,'Marry',7046);
insert into instance6 values(0733,'TOny',NULL); 
insert into instance6 values(0734,'Mario',NULL);
update instance6 set name = 'Tony' where id = 0733;
-- 唯一约束可以为null 在sql中null与任何值都不同
-- 创建表之后指定添加唯一约束
alter table instance6 add constraint unique_name unique(name);  
-- unique_name只是一个约束名字 在删除这个约束的时候才有点用
insert into instance6 values (0735,'James',7047);
-- 删除唯一约束
alter table instance6 drop index unique_name;
show index from instance6;

-- 5. 默认约束   default 
-- 默认值约束用来指定某列的默认值
create table mydb1.instance7 (
id int,
name varchar(20),
address varchar(10) default '武汉' -- 指定默认值
);
insert into instance7(id,name) values(1001,'James');
insert into instance7 values(1002,'Marry','泸州');
insert into instance7 values(1003,'Tony',NULL);
delete from instance7 where id = 1003;
update instance7 set address = '武汉' where id = 1003; 
alter table instance7 modify address varchar(20) default '克拉玛依';
alter table instance7 modify address varchar(20) default NULL;




-- 6. 零填充约束 zerofill 
-- 在数值类型中 如果输入的数不及定义的长度 那么会在输入的数字前面补0凑齐
-- zerofill默认是int(10)
-- 当使用zerofill时 默认会自动加上unsigned属性 
-- 会从如-127-128 -> 0-256
create table instance8 (
id int zerofill,
name VARCHAR(20)
);
insert into instance8 values(123,'James');
insert into instance8 values(1,'Tony');
-- 删除约束
alter table instance8 modify id int;
insert into instance8 values(1234,'Marry');


-- 7. 外键约束   foreign key 
-- 创建外表 
create table instance9 (
name varchar(20) not null,
id int not null
);
alter table instance9 add primary key(name);
alter table instance9 add age int ;
desc instance9;
insert into instance9 values
('James',1001,19),
('Tony',1002,20),
('Marry',1003,21),
('Mario',1004,22);
select * from instance9;
-- 创建主表
create table instance10 (
name varchar(20) primary key,
id int not null,
age int,
foreign key(name) references instance9(name)
);
insert into instance10 values('Tom',1005,500);
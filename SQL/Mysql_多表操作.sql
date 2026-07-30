create database mybd2;
-- 多表关系包括 一对一  一对多  多对多
-- 一对一 : 在任一表中添加唯一外键,指向另一主键,确保一对一关系
-- 一对多/多对一 : 在任一表中的某一行对应主表的多行信息
-- 多对多 : 多对多关系实现必须借助第三张表.中间表至少包含两个字段,将多对多的关系拆成一对多的关系,中间表至少要有两个外键,这两个外键分别指向原来的那两张表的主键

-- 外键约束 专门用于多表关系的一种约束手段,经常和主键约束一起使用 对于两个具有关联关系的表而言,相关联的字段中主键所在的就是主表(父表),外键所在的表就是从表(子表)
-- 在外键约束中 定义一个外键时必须遵守的规则 :
  -- 主表必须是已经存在在数据库当中的或者正在创建的表
  -- 必须为主表定义主键
  -- 主键不能包含null 但允许在外键中出现null 也就是说 只要外键的每个非空值出现在指定的主键中,那么这个外键的内容就是正确的
  -- 在主表的表面名后面指定列名或列名的组合  这个列或列的组合必须是主表的主键或候选键 
  -- 外键中列的数目必须和主表中主键的列的数目相同
  -- 外键中列的数据类型必须和主表主键中对应的数据类型相同
create database mydb2;
drop database mybd2;
use mydb2;
-- 创建部门表 主表
create table if not exists mydb2.dept(
deptno VARCHAR(20),
name varchar(20)
);
alter table dept add primary key(deptno);
-- 创建员工表 并创建外键约束 从表  - 方式1
create table if not exists mydb2.emp(
eid varchar(20) primary key,
ename varchar(20),
age int,
dept_id varchar(20),
constraint rmp_fk foreign key(dept_id) references dept(deptno)
);
drop table dept;
drop table emp;
desc dept;
desc emp;
-- 通过修改表结构的方式添加外键约束 -- 方式2
alter table emp add constraint dept_fk foreign key(dept_id) references dept(depyno);

-- 添加主表数据  注意必须先给主表添加数据 
insert into dept values
('1001','销售部'),
('1002','研发部'),
('1003','财务部'),
('1004','人事部');
-- 添加从表数据  注意外键列的值不能随便乱写 必须依赖主键列 不能添加主表主键,没有的数据
insert into emp values
(1,'James',20,1001),
(2,'Marry',21,1001),
(3,'Jone',21,1001),
(5,'Jerry',22,1002),
(6,'Allen',24,1002),
(7,'Lisa',27,1003),
(8,'Leo',28,1003),
(9,'Trump',20,1004);
-- 不能添加主键中没有的元素
insert into emp values 
(10,'Kalle',30,1005);

-- 删除数据
-- 主表主键的数据在被依赖时不可以被删除,未被依赖时可以删除
-- 从表的数据可以随意删除
-- 只要数据还在受其他表的依赖就不能改变,包括删除表也不可以
insert into dept values (1005,'测试部');
delete from dept where deptno = 1001; -- cannot delete
delete from dept where deptno = 1005;
delete from emp where ename = 'Jone';

-- 删除外键约束  删除之后就会解除主表和从表之间的关联关系
alter table dept drop foreign key (rem_fk); 
-- 这就是为什么要在constraint后面给一个外键的名称
-- 不清楚外键的名称可以去逆向表到模型里面创建主从表之间的关系,点击连线查看


-- 多对多的外键约束
-- 在多对多关系中 a表的一行对应b表的多行,b表的一行也对应a表的多行,所以我们需要新增一个中间表,来建立多对多关系
-- 中间表至少需要有两列来分别对应另外两个表的主键列
-- 中间表对应另外两个表的两列就是外键列,受到主键列的约束,所以中间表是从表
-- 另外两个表则是主表 
-- 创建学生表student(左侧主表)
create table student(
sid int primary key auto_increment,
name varchar(20),
age int ,
gender varchar(20)
);
-- 创建课程表  course(右侧主表)
create table course(
cid int primary key auto_increment,
cidname varchar(20)
);
-- 创建中间表 从表
create table score(
sid INT,
cid INT,
score double
);
-- 建立外键约束
alter table score add constraint s_score foreign key(sid) references student(sid);
aLTER TABLE score add constraint c_score foreign key(cid) references course(cid);
-- 添加数据
insert into student VALUES
(1,'小龙女',18,'女'),
(2,'阿紫',19,'女'),
(3,'周芷若',20,'男');
insert into course VALUES
(1,'语文'),
(2,'数学'),
(3,'英语');
insert INTO SCORE VALUES
(1,1,110),
(1,2,120),
(1,3,136),
(2,1,90),
(2,3,120),
(3,2,110),
(3,3,120);
insert into score values (4,1,100);-- cannot add a child row




-- 多表联合查询
-- 数据准备 外键约束对多表查询并没有什么影响
create table if not exists dept1(
deptno varchar(20) primary key,
name varchar(20)
);
create table if not exists exp1(
eid varchar(20) primary key,
ename varchar(20),
age int ,
dept_id varchar(20)
);
rename table exp1 to emp1;
insert into dept1 values
('1001','销售部'),
('1002','研发部'),
('1003','财务部'),
('1004','人事部');

insert into emp1 values
(1,'James',20,1001),
(2,'Marry',21,1001),
(3,'Jone',21,1001),
(5,'Jerry',22,1002),
(6,'Allen',24,1002),
(7,'Lisa',27,1003),
(8,'Leo',28,1003),
(9,'Trump',20,1005),
(10,'Rolles',33,1005);
use mydb2;
-- 交叉连接查询 会产生笛卡尔积 select * from a,b;
-- 笛卡尔积可理解为两张表的数据相乘,第一张表的每一列和另一张表的任一列进行匹配 得到mn行数据
select * from dept1,emp1;
-- 内连接查询 使用关键字inner join -- inner可以省略
-- 实际上求得是多张表的交集
-- 隐式内连接(SQL92)标准 select * from a,b where 条件;
select * from dept1,emp1 where dept1.deptno = emp1.dept_id;
-- 显示内连接(SQL99)标准 select * from a join b on 条件;
select * from dept1 inner join emp1 on dept1.deptno = emp1.dept_id;
-- 查询某部的员工
select * from dept1 inner join emp1 on dept1.deptno = emp1.dept_id and dept1.name = '研发部';
select * from dept1 join emp1 on deptno = dept_id and name in ('研发部','销售部');
select name,count(1) as '员工数量' from dept1 join emp1 on deptno = dept_id group by name order by '员工数量' desc;
select name ,count(1) as 数量 from dept1 join emp1 on deptno = dept_id group by name having 数量 >= 3 order by 数量 desc;








-- 外连接查询 使用关键字outer join -- outer可以省略

-- 左边连接 left outer join...select * from a left join b on 条件;
-- 输出左表的所有数据
use mydb2;
-- 查询哪些部门有员工,哪些部门没有员工
select * from dept1 left outer join emp1 on deptno = dept_id;
-- 多张表的左外连接写法
select * from A 
left outer join B on 条件1             
left outer join C on 条件2
left outer join D on 条件3
                            
-- 右边连接 right outer join ...select * from a right join b on 条件;
-- 输出右表的所有数据               
-- 哪些员工有对应的部门,哪些没有
select * from  right join  on deptno = dept_id;
-- 多张表的右外连接
select * from A 
right join B on 条件1
right join C on 条件2
right join D on 条件3

-- 满外连接 full outer join...select * from a full join b on 条件; 并集
-- 但是full join在oracle中支持,但在mysql中的支持并不好,用union替换
select * from dept1 full join emp1 on deptno = dept_id; -- error mysql对full join的支持一般
select * from dept1 left join emp1 on deptno = dept_id 
UNION (all)
select * from dept1 right outer join emp1 on deptno = dept_id;
-- union是将两个查询结果上下拼接并去重
-- union all 是将两个查询姐过上下拼接不去重




-- 子查询 select的嵌套
-- 在一个完整的查询语句当中 嵌套若干个不同功能的小查询.从而一起完成复杂查询的一种编写形式,  也就是包含select嵌套的查询.
-- 1. 单行单列 返回一个具体列的内容 可以理解为一个单值数据
-- 2. 单行多列 返回一行数据中多个列的内容
-- 3. 多行单列 返回多行记录之中一列的内容,相当于给出了一个操作范围
-- 4. 多行多列 查询返回的结果是一张临时表
-- 查询年龄最大的员工信息,显示信息包含员工号,员工名字,员工年龄
select max(age) from emp1 ; -- 33
select * from emp1 where age = (select max(age) from emp1);
-- 查询研发部和销售部的员工信息,包括员工号,员工名字
desc emp1;
desc dept1;
select * from emp1 where dept_id in (select deptno from dept1 where name in ('销售部','研发部'))
-- union all -- 要求必须栏目完全相同才可以拼接 
-- 所以在这里不能用union all拼接
select * from dept1 join  emp1 on deptno = dept_id where deptno in (select deptno from dept1 where name in ('销售部','研发部'));
select * from dept1 inner join emp1 on deptno = dept_id and (name = '销售部' or name = '研发部');
select deptno from dept1 where (name = '销售部' or name = '研发部');

select deptno,name,eid,ename,age 
from dept1 
join emp1 on deptno = dept_id 
where dept_id in 
(select deptno from dept1 where name = '销售部' or name = '研发部');

-- 查询研发部23岁以下的员工信息
-- 子查询
select deptno,name,eid,ename,age 
from dept1 
inner join emp1 on deptno = dept_id
where deptno = 
(select deptno from dept1 where name = '研发部') 
and age <= 23;
-- 关联查询
select * 
from dept1 
join emp1 on deptno = dept_id 
where (name = '研发部' and age <= 23);



-- 表自关联 将一张表当成多张表来使用
-- 在部门表中查询研发部的信息
select * from dept1 where name = '研发部';
-- 在员工表中查询年龄小于30岁的员工信息
select * from emp1 where age <30;
-- 将这两个表查询的结果进行关联查询
select * from
(select * from dept1 where name = '研发部') as d
inner join 
(select * from emp1 where age < 30) as e
on d.deptno = e.dept_id 
having age > 23;
 
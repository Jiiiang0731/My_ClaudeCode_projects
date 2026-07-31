-- 自关联查询
-- MySQL有时在信息查询的时候需要对表自身进行关联查询,就是自己和自己进行关联,一张表当成多张表来使用, 注意 自关联时必须给表起别名
use mydb2;
create table t_sanguo (
eid int primary key,  -- 员工的编号
ename varchar(20),
manager_id int,  -- 上级领导的编号
FOREIGN key (manager_id) references t_sanguo(eid) -- 添加自关联约束
);
insert into t_sanguo values(1,'刘协',NULL);
insert into t_sanguo values(2,'刘备',1);
insert into t_sanguo values(3,'关羽',2);
insert into t_sanguo values(4,'张飞',2);
insert into t_sanguo values(5,'曹操',1);
insert into t_sanguo values(6,'许褚',5);
insert into t_sanguo values(7,'典韦',5);
insert into t_sanguo values(8,'孙权',1);
insert into t_sanguo values(9,'周瑜',8);
insert into t_sanguo values(10,'鲁肃',8);

-- 进行关联查询
-- 1. 查询每个三国人物及他的上级信息 如 关羽 刘备
select t1.ename as clerk,t2.ename as manager from t_sanguo as t1 ,t_sanguo as t2 
where t1.manager_id = t2.eid;

-- 2.查询所有人物及其上级
select t1.ename,t2.ename 
from t_sanguo as t1 
left join t_sanguo as t2 
on t1.manager_id = t2.eid;

-- 3.查询所有人的上级和上上级
select t1.ename as clerk ,t2.ename as manger, t3.ename as mamanager 
from 
t_sanguo as t1 
left join 
t_sanguo as t2 
on t1.manager_id = t2.eid
left join 
t_sanguo as t3 
on t2.manager_id = t3.eid;







-- 多表操作练习
create table dept2 (
deptno int primary KEY,
dename varchar(14),
loc varchar(13)
);

insert into dept2 values
(10,'accounting','New_york'),
(20,' research','Dallas'),
(30,'sales','Chicago'),
(40,'operation','Boston');


create table emp2(
empno int primary key,
ename varchar(20),
job varchar(20),
mgr int ,  -- 员工直属领导编号
hiredate date,
sal double ,
comm double,
deptno int  -- 对应dept2中的外键
);

-- 将员工表和部门表之间创建一个主键外键的关系
alter table emp2 add constraint dept_emp foreign key(deptno) references dept2(deptno);
insert into emp2 values(7369,'smith','clerk',7902,'1980-12-17',800,null,20);
insert into emp2 values(7499,'allen','salesman',7698,'1981-02-20',1600,300,30);
insert into emp2 values(7521,'ward','salesman',7698,'1981-02-22',1250,500,30);
insert into emp2 values(7566,'jones','manager',7839,'1981-04-02',2975,null,20);
insert into emp2 values(7654,'martin','salesman',7698,'1981-09-28',1250,1400,30);
insert into emp2 values(7698,'blake','manager',7839,'1981-05-01',2850,null,30);
insert into emp2 values(7782,'clark','manager',7839,'1981-06-09',2450,null,10);
insert into emp2 values(7788,'scott','analyst',7566,'1987-07-03',3000,null,20);
insert into emp2 values(7839,'king','president',null,'1981-11-17',5000,null,10);
insert into emp2 values(7844,'turner','salesman',7698,'1981-09-08',1500,0,30);
insert into emp2 values(7876,'adams','clerk',7788,'1987-07-13',1100,null,20);
insert into emp2 values(7900,'james','clerk',7698,'1981-12-03',950,null,30);
insert into emp2 values(7902,'ford','analyst',7566,'1981-12-03',3000,null,20);
insert into emp2 values(7934,'miller','clerk',7782,'1981-01-23',1300,null,10);

create table salgrade (
grade int,
losal double , -- 最低工资
hisal double  -- 最高工资
);
insert into salgrade values (1,700,1200);
insert into salgrade values (2,1201,1400);
insert into salgrade values (3,1401,2000);
insert into salgrade values (4,2001,3000);
insert into salgrade values (5,3001,9999);
alter table 
-- 返回拥有员工的部门名,部门号
select empno,ename,job,mgr,hiredate,sal,comm,t2.deptno,dename,loc
from emp2 t1 inner join dept2 t2
on t1.deptno = t2.deptno;

-- 工资水平多于Smith的员工信息;
select * from emp2 
where sal > (select sal from emp2 where ename = 'Smith');

-- 返回员工和所属经理的姓名
select t1.ename as clerk,t2.ename as manager 
from emp2 as t1 inner join emp2 as t2 
on t1.mgr = t2.empno;

-- 返回雇员的雇佣日期早于其经理雇佣日期的员工及其经理的姓名
select t1.ename 
as clerk,t1.hiredate as c_d ,t2.ename as manager,t2.hiredate as  m_d
from emp2 as t1 inner join emp2 as t2 
on t1.mgr = t2.empno 
where t1.hiredate < t2.hiredate;

-- 返回员工姓名及其所在的部门名称
select t1.ename,t2.dename 
from emp2 as t1 join dept2 as t2 
on t1.deptno = t2.deptno ;

-- 返回从事clerk工作的员工姓名和所在部门的名称 
select t1.ename,t2.dename 
from emp2 as t1 join dept2 as t2
on t1.deptno = t2.deptno 
where t1.job = 'clerk';

-- 返回部门号及其本部门的最低工资
select t3.deptno,t3.dename,min(sal)
from emp2 as t1 
inner join salgrade as t2 
on t1.sal > t2.losal and t1.sal < t2.hisal
inner join dept2 as t3 
on t1.deptno = t3.deptno
group by t3.deptno,t3.dename;

-- 返回销售部的所有员工信息
select * from
emp2 as t1 inner join dept2 as t2 
on t1.deptno = t2.deptno 
where dename = 'Sales';

-- 返回工资水平多于平均水平的员工
select t1.*
FROM emp2 as t1 
where sal > (select avg(sal) from emp2);

-- 返回与Scott从事相同工作的员工
select * from emp2 as t1 
where job = (select job from emp2 where ename = 'Scott')
and ename != 'Scott';

-- 返回与30部门员工工资水平相同的员工姓名与工资 
select * from emp2 
where sal > any 
(select t1.sal from emp2 as t1 
inner join dept2 as t2 
on t1.deptno = t2.deptno );

-- 返回员工工作及其从事次工作的最低工资
select t4.ename ,t4.job,MS
from emp2 as t4 
inner join 
(select t1.job as ejob,min(sal) as MS  
from emp2 as t1 
inner join salgrade as t2 
on t1.sal > t2.losal and t1.sal < t2.hisal 
inner join dept2 as t3 
on t1.deptno = t3.deptno
group by t1.job) 
as t5
on t4.job = ejob;

select job,min(sal) from emp2 
group by job;


-- 计算出员工的年薪 并且以年薪排序
select ename,(sal * 12 + ifnull(comm,0)) as YearSal 
from emp2
order by YearSal desc;

-- 返回工资处于第四等级的员工姓名
select t1.ename,t2.grade,t1.sal 
from emp2 as t1 
inner join salgrade as t2 
on t1.sal > t2.losal and t1.sal < t2.hisal 
having t2.grade = 4;

-- 返回工资为第二等级的职员名字 部门所在地
select t1.ename,t2.grade,t3.loc
from emp2 as t1 
inner join salgrade as t2 
on t1.sal > t2.losal and t1.sal < t2.hisal 
inner join dept2 as t3 
on t1.deptno = t3.deptno 
where t2.grade = 2;

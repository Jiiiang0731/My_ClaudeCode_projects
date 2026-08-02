CREATE TABLE mydb3.student (
    id INT primary key,
    name VARCHAR(20),
    gender CHAR(1),
    chinese INT,
    english INT,
    math INT
);

INSERT INTO student(id,name,gender,chinese,english,math)
VALUES
(1,'张明','男',89,78,90),
(2,'李进','女',67,53,95),
(3,'王五','女',87,78,77),
(4,'李一','女',88,98,92),
(5,'李财','男',82,84,67),
(6,'张宝','男',55,85,45),
(7,'黄蓉','女',75,65,30);
-- if(expr,v1,v2) 如果表达式的expr成立则返回v1,否则返回v2
select if(pow(6,7) > pow(7,6),1,0);
select pow(6,7);
select if(english > math ,'文','理') as major,
count(*) as num
from student
group by major
 ;

-- ifnull(v1,v2) 如果v1是null 那么就用v2的值替代v1
select ifnull(null,0);

-- isnull(expression) 判断expression是不是null 否0是1
select isnull(null);

-- nullif(expr1,expr2) 比较两个字符串 
-- 如果字符串expr1与expr2相等返回null 不相等就返回expr1
select nullif('apple','apple');
select nullif('apple','banana');




-- case when语句
-- case EXPRESSION   case表示函数的开始
-- 条件判断语句满足condition则返回对应的result
--   when condition then result1 
--   when condition then result2
--   when condition then result3
--   ...
--   else result
-- END  end表示函数的结束

select name,
case  -- case后面如果有字段的话when后面就只能跟固定的数值,否则用表达式
  when chinese<100 and chinese >90 then '优秀'
  when chinese<90 and chinese >80 then '良好'
  when chinese<80 and chinese > 60 then '及格'
  else '重修'
end
from student;



-- 窗口函数
-- 又称为开窗函数 与Oracle的窗口函数类似
-- 窗口函数是相对与聚合函数来说的,聚合函数在计算完数据之后会将多行数据最后变成一行数据输出.而窗口函数可以在聚合函数的基础之上保留原有的行数,不会变为一行

-- window_function(expr) over(
-- partition by  
-- 将数据拆分成多个组 类似于group by 省略则会将所有数据作为一个组进行计算
-- order by  
-- 用于指定分区内的排序方旭 与order by的作用类似
-- frame_clause --用于在当前分区内指定一个计算窗口,也就是一个与当前行相关的数据子集
-- );


-- 序号函数  实现分组排序,并添加序号,以下三个函数只在添加序号的时候有点区别
-- row_number()
-- rank()
-- dense_rank()
use mydb3;
create table employee(
dname varchar(20),
eid
);
INSERT INTO employee(dname,eid,ename,hiredate,salary)
VALUES
('研发部','1001','刘备','2021-11-01',3000),
('研发部','1002','关羽','2021-11-02',5000),
('研发部','1003','张飞','2021-11-03',7000),
('研发部','1004','赵云','2021-11-04',7000),
('研发部','1005','马超','2021-11-05',4000),
('研发部','1006','黄忠','2021-11-06',4000),
('销售部','1007','曹操','2021-11-01',2000),
('销售部','1008','许褚','2021-11-02',3000),
('销售部','1009','典韦','2021-11-03',5000),
('销售部','1010','张辽','2021-11-04',6000),
('销售部','1011','徐晃','2021-11-05',9000),
('销售部','1012','曹洪','2021-11-06',6000);

select dname,eid,ename,salary,
ROW_NUMBER() over(   -- 连续不并列
partition by dname
order by salary desc) as rn
from employee;

select *,
rank() over(  -- 有并列不连续
partition by dname
order by salary 
) as rn
from employee;

select dname,eid,ename,salary,
dense_rank() over(   -- 并列且连续
partition by dname 
order by salary
) as rn
from employee;
-- 求出每个部门的薪资排在前三名的员工  分组求TOP N
select * from 
(
  select dname,eid,ename,salary,
  dense_rank() over(
  partition by dname
  order by salary desc) as rn
  from employee
) as t 
where t.rn <= 3;

-- 求出每个部门的薪资排在前三名的员工  不分组求TOP N
select * from 
(
  select dname,eid,ename,salary,
  dense_rank() over( 
  order by salary desc) as rn
  from employee
) as t 
where t.rn <= 3;


-- 前后函数
-- lag() and lead()
-- 返回位于当前行的前n行(lag(expr,n))或者后n行(lead(expr,n))的expr的值
-- 比如查询前1名同学和当前同学的成绩差值
SELECT
*,
datediff(hiredate,time1),
datediff(hiredate,time2)
from
(SELECT
dname,
ename,
salary,
hiredate,
lag(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as time1,
lag(hiredate,2) over(partition by dname order by hiredate) as time2
from employee) AS t1
;

SELECT
*,
datediff(hiredate,time1) as diff1,
datediff(hiredate,time2) as diff2
from
(SELECT
dname,
ename,
salary,
hiredate,
lead(hiredate,1,'2000-01-01') over(partition by dname order by hiredate) as time1,
lead(hiredate,2) over(partition by dname order by hiredate) as time2 
from employee) as t1
;

-- 头尾函数
-- first_value(expr) and last_value(expr) 返回第一个值 / 返回最后一个值
select 
dname,
ename ,
salary,
hiredate,
first_value(salary) over(partition by dname order by hiredate), 
-- 到目前行日期为止部门第一个入职的人的薪资
last_value(salary) over(partition by dname order by hiredate)
-- 到目前行日期为止部门最后一个入职的人的薪资
from employee;



-- 其他函数
-- nth_value(expr,n)
-- 返回窗口中第n个expr值,expr可以是表达式也可以是列名
select 
dname,
ename,
salary,
hiredate,
nth_value(salary,2) over(partition by dname order by hiredate) as second_sal,
nth_value(salary,3) over(partition by dname order by hiredate) as third_sal
from employee;
-- ntile(n)
-- 将分区中的有序数据分为n个等级  记录等级数
-- 如可以将每个部门的员工按照入职日期分为三组
select 
dname,
ename,
salary,
hiredate,
ntile(3) over(partition by dname order by hiredate) as tn1,
ntile(4) over(partition by dname order by hiredate) as tn2
from employee;

-- 取出每一个部门的第一组员工
SELECT
*
from
(select
dname,
ename,
salary,
hiredate,
ntile(3) over(partition by dname order by hiredate ) as tn1
-- ntile(4) over(partition by dname order by hiredate ) as tn2
from employee) as t1
where t1.tn1 = 1;
-- 开窗聚合函数 sum avg min max
select
*,
sum(salary) over(
partition by dname 
order by hiredate asc) as Pv1
from employee;

select 
*,
sum(salary) over(
partition by dname 
) as c1
from employee;

select * ,
sum(salary) over(
partition by dname 
order by salary 
rows between 3 preceding and current row -- 前三行加本行的和
) as c1
from employee;

select * ,
sum(salary) over(
partition by dname 
order by salary 
rows between 3 preceding and 1 following -- 前三+本行+后一
) as c1
from employee;

select *,
sum(salary)
over(
partition by dname 
order by salary 
rows between current row and unbounded following -- 当前到最后
) as c1
from employee;
desc employee;


-- 分布函数 cume_dist() and percent_rank()
-- 分组内小于等于当前rank值的行数 / 分组内总行数
-- 小于等于当前行数值的数量占比多少
select 
dname,
ename,
salary,
cume_dist() over(order by salary ) as rn1,
cume_dist() over(partition by dname order by salary) as rn2
from employee; 

-- percent_rank 是按照 (rank - 1)  / (row - 1) 得到的结果
select 
dname,
ename,
salary,
percent_rank() over(order by salary),
percent_rank() over(partition by dname order by salary)
from employee;

select 
dname,
ename,
salary,
rank() over(partition by dname order by salary) as rn1,
percent_rank() over(partition by dname order by salary) as rn2
from employee;

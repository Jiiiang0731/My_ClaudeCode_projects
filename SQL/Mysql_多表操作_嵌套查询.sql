-- 子查询关键字


-- all
-- select from where c > all (查询语句)
-- 查询年龄大于1003部门所有年龄的员工信息
use mydb2;
select * from emp1 
where age > 
all(select age from emp1 where dept_id = 1003);

select * from emp1
where dept_id not in 
(select deptno from dept1);


-- any 只需要满足any后面语句中的任意一个就行  or
-- some  和any用法一模一样,可以理解为any的别名
select * from emp1 
where age > 
any(select age from emp1 where dept_id = 1003);

select * from emp1 
where age > 
some(select age from emp1 where dept_id = 1003)
and dept_id != 1003;

-- in / not in
SELECT deptno,eid,ename,age from emp1 join dept1 
on deptno = dept_id 
where age not in 
(select deptno from dept1 where name = '研发部' and name = '销售部');
desc dept1;


-- exists
-- 返回值是True和False 效率比in更高 在实际大数据工作中推荐使用exists
select * FROM emp1where exists (select * from emp1); -- 输出整张表
select * from emp1 where exists (select 1); -- 同上,全表输出
-- 查询公司是否有大于60岁的员工
select * from emp1 where exists (select * from emp1 where age > 30);
-- 只要满足条件就会输出整个表格..exists在查询时会遍历整个表格去寻找是否存在满足条件的行,只要存在任意一个就为True,也会接着往后继续遍历,所以会输出全表
-- 也可以通过改动exists查询语句中的条件来使得输出的结果满足要求
select * from emp1 as e where exists (select * from emp1 where e.age> 30); 

-- 查询有所属部门的员工信息
select * from emp1 a where exists (select * from dept1 b where a.dept_id = b.deptno);
select * from emp1 a where dept_id in (select deptno from dept1 b where a.dept_id = b.deptno);
select * from emp1 inner join dept1 on dept_id = deptno;
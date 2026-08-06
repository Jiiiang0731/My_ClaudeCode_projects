create database mydb6 ;
/*
create function func_name([param_name type[,...]])
return type 
[characteristic...]
begin 
  routine_body 
end;
*/
use mydb6;
CREATE TABLE dept (deptno INT PRIMARY KEY COMMENT '部门编号', dname VARCHAR (20) COMMENT '部门名称', loc VARCHAR (20) COMMENT '所在地');
  INSERT INTO dept (deptno, dname, loc)
  VALUES
  (10, '教研部', '北京'),
  (20, '学工部', '上海'),
  (30, '销售部', '广州'),
  (40, '财务部', '武汉');
  
  -- 2. 员工表 emp
  DROP TABLE
  IF EXISTS emp;
    CREATE TABLE emp (
      empno INT PRIMARY KEY COMMENT '员工编号',
      ename VARCHAR (10) COMMENT '姓名',
      job VARCHAR (10) COMMENT '岗位',
      mgr INT COMMENT '直属领导编号',
      hiredate DATE COMMENT '入职日期',
      sal DECIMAL (10, 2) COMMENT '基本工资',
      comm DECIMAL (10, 2) COMMENT '奖金',
      deptno INT COMMENT '所属部门编号'
    );
    INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
    VALUES
    (1001, '甘宁', '文员', 1013, '2000-12-17', 8000.00, NULL, 20),
    (1002, '魔丽丝', '销售员', 1006, '2001-02-20', 16000.00, 3000.00, 30),
    (1003, '殷天正', '销售员', 1006, '2001-02-22', 12500.00, 5000.00, 30),
    (1004, '刘备', '经理', 1009, '2001-04-02', 29750.00, NULL, 20),
    (1005, '谢逊', '销售员', 1006, '2001-09-28', 12500.00, 14000.00, 30),
    (1006, '关羽', '经理', 1009, '2001-05-01', 28500.00, NULL, 30),
    (1007, '张飞', '经理', 1009, '2001-09-01', 24500.00, NULL, 10),
    (1008, '诸葛亮', '分析师', 1004, '2007-04-19', 30000.00, NULL, 20),
    (1009, '冒同牛', '董事长', NULL, '2001-11-17', 50000.00, NULL, 10),
    (1010, '韦一笑', '销售员', 1006, '2001-09-08', 15000.00, 0.00, 30),
    (1011, '周泰', '文员', 1008, '2007-05-23', 11000.00, NULL, 20),
    (1012, '程普', '文员', 1006, '2001-12-03', 9500.00, NULL, 30),
    (1013, '庞统', '分析师', 1004, '2001-12-03', 30000.00, NULL, 20),
    (1014, '黄盖', '文员', 1007, '2002-01-23', 13000.00, NULL, 10);
    
    -- 3. 薪资等级表 salgrade
    DROP TABLE
    IF EXISTS salgrade;
      CREATE TABLE salgrade (grade INT PRIMARY KEY COMMENT '薪资等级', losal INT COMMENT '等级最低工资', hisal INT COMMENT '等级最高工资');
      INSERT INTO salgrade (grade, losal, hisal)
      VALUES
      (1, 7000, 12000),
      (2, 12010, 14000),
      (3, 14010, 20000),
      (4, 20010, 30000),
      (5, 30010, 99990);


/*
create function func_name([param_name type[,...]])
return type 
[characteristic...]
begin 
  routine_body 
end;
*/

-- 允许创建函数权限信任
set global log_bin_trust_function_creators = True ;
-- 创建存储函数
delimiter $$
create function myfunc1_emp() returns int 
READS SQL DATA
begin 
-- 定义一个局部变量来保存返回的值
declare cnt int default 0;
select count(*) into cnt from emp;
return cnt;
end $$
delimiter ;


CALL myfunc1_emp();
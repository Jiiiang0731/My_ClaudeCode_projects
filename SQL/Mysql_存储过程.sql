create database mydb5;
-- 存储过程就是将sql语句写好后封装,以后需要执行相应功能时就调用已封装好的sql语句的过程就是存储
-- 存储过程相当于在 python / java 语言中的函数或者方法
-- 存储过程有输入输出的参数 可以声明变量 有if else while 等控制语句,通过编写存储过程,可以实现复杂的逻辑功能
-- 函数与存储过程的普遍特性 : 模块化 封装 代码复用
-- 速度快 只有首次执行需要经过编译和优化步骤 后续被调用可以直接执行 省去以上步骤



-- 格式
-- delimiter 自定义结束符号
-- create procedure 存储名 ([IN, OUT, INOUT] 参数名 数据类型...)
-- begin
--   sql语句 end自定义的结束符号
--   delimiter;
 
-- 数据准备
-- 1. 部门表 dept
use mydb5;
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
      
      
-- a basic example 
    delimiter $$ -- 一般使用 $$ or \\
    CREATE PROCEDURE proc01 ()
    BEGIN
      SELECT
        empno,
        ename
      FROM
        emp;
    END $$
delimiter ;   -- 这一个delimiter和;之间必须存在一个空格不然illegal
    
-- 调用存储过程  
call proc01;

-- 变量定义
-- 局部变量
-- declare var_name type [default var_value];
-- declare nickname varchar(20) default '小明';
    delimiter $$
    CREATE PROCEDURE proc02 ()
    BEGIN
      DECLARE nickname VARCHAR (20) DEFAULT '小明'; -- 定义临时变量
      SET nickname = 'James';  -- 赋值
      SELECT nickname; -- 输出变量的值
    END $$
    delimiter ;
    -- declare的局部变量在procedure之外都是不能调用的
    
call proc02;


-- 用select into语句为变量赋值
delimiter $$ 
create procedure proc03()
begin 
declare my_ename varchar(20) default '小明';
select ename into my_ename from emp where empno = 1001;
select my_ename;
end $$
delimiter ;


CASE case_valueCASE case_value
	WHEN when_value THEN
		statement_list
	ELSE
		statement_list
END CASE;

	WHEN when_value THEN
		statement_list
	ELSE
		statement_list
END CASE;

CALL proc03;


-- 用户变量
-- 格式@[name]  用户自定义,在当前会话(连接)有效 类比java的成员变量

delimiter $$
create procedure proc04()
BEGIN
 set @var_name01 = '北京';
 select @var_name01;
end $$
delimiter ; 
call proc04;

select @var_name01;


-- 系统变量  可以理解为sql已经设置好的变量

-- 全局变量                                      由服务器自动将他们初始化为默认值 这些默认值可以通过my.ini这个文件修改

-- 会话变量 由MySQL在建立连接时进行初始化.MySQL会将当前所有的全局变量复制一份来当作会话变量

-- 可以理解为会话变量是全局变量的复制件 但是两种变量的作用域不同
-- 全局变量是对整个服务器都起作用  但是会话变量的修改只会影响到当前对话中的变量值



-- 全局变量  @@ global.[name]
USE mydb5;
-- 查看全局变量
show global variables;
-- 修改全局变量的值
set global sort_buffer_size = 40000;
set @@global.sort_buffer_size = 40000;
select @@global.sort_buffer_size;


-- 会话变量  由系统提供 仅在当前对话(连接)中起效
-- 语法 @@session.[name]
-- 查看会话变量
show session VARIABLES;
-- 查看某会话变量
select @@session.auto_increment_increment;
-- 修改会话变量的值
set session sort_buffer_size =  50000;
set @@session.sort_buffer_size = 50000;
select @@session.sort_buffer_size;




-- 存储过程传参 in 
-- in表示传入的参数 可以传入数值或者变量 即使传入变量 并不会更改变量的值 可以内部更改 仅仅作用在函数范围之内
-- 封装有参数的存储过程 传入员工编号 查找员工的信息
delimiter $$
create procedure proc05(in param_empno int)
begin 
select * from emp where empno = param_empno;
end $$
delimiter ;

call proc05(1005);

-- 封装有参数的存储过程 可以通过传入部门名称和薪资 查询指定部门 并且薪资大于指定值的员工信息
    delimiter $$
    CREATE PROCEDURE proc06 (IN param_dname VARCHAR (20), IN param_sal DECIMAL (10, 2))
    BEGIN
      SELECT
        *
      FROM
        emp AS t1
        INNER JOIN dept AS t2 ON t1.deptno = t2.deptno
      WHERE
        t2.dname = param_dname
        AND t1.sal > param_sal;
    END $$
    delimiter;
call proc06('教研部',20000);


-- 传出参数 out
-- 封装有参数的存储过程 传入员工编号 返回员工的名字
    delimiter $$
    CREATE PROCEDURE proc07 
    (
      IN in_param_empno INT,
      OUT out_ename VARCHAR (20),
      OUT out_sal DECIMAL (10, 2)
    )
    BEGIN
      SELECT
        ename,sal INTO out_ename,out_sal
      FROM
        emp
      WHERE
        empno = in_param_empno;
    END $$
    delimiter;

call proc07(1003,@out_param_ename,@out_param_sal); -- @out_param_ename 是用来接收形参的,可以select
select @out_param_ename name,@out_param_sal sal;



-- 传参inout
-- input表示从外部传入参数经过修改后可以返回的变量 既可以使用传入变量的值也可以修改变量的值  即使函数执行完
-- 传入一个数字 传出这个数字的十倍
delimiter $$
create procedure proc08(inout num int)
begin
set num = num * 10;
end $$
delimiter ;

set @inout_num = 3;
call proc08(@inout_num);

select @inout_num;

    -- 传入 员工名字 拼接部门号 传入薪资 求出年薪
    delimiter $$
    CREATE PROCEDURE proc09 (INOUT ename1 VARCHAR (20), INOUT sal DECIMAL (10, 2))
    BEGIN
      SET sal = sal * 12;
      SELECT
        concat_ws('_', ename1, t2.deptno),
        t1.job,
        sal,
        t2.dname
      FROM
        emp AS t1
        INNER JOIN dept AS t2 ON t1.deptno = t2.deptno
      WHERE
        t1.ename = ename1;
    END $$
    delimiter;
set @param_sal = 29750;
set @param_ename = '刘备';
call proc09(@param_ename,@param_sal);
select @param_ename as name ,@param_sal as Ys;


delimiter $$
create procedure proc10(inout ename varchar(20),inout sal decimal(10,2))
BEGIN
select concat_ws('_',ename,deptno) 
from emp 
where emp.ename = ename ;
end $$
delimiter ;

set @param_ename = '关羽';
set @param_sal = 28500;
call proc10(@param_ename,@param_sal);
select @param_ename as ename1,@param_sal as Ys;



-- 流程控制 判断
-- if语句包含多个条件判断 根据结果为True False执行语句,与编程中的if elseif else类似
-- if search_condition_1 then statement_list_1
--     [elseif search_condition_2 then statement_list_1];
--     ...;
--     [else statement_list_n];
-- end if 
-- 存储案例-if
-- 输入学生成绩  来判断成绩的级别
/* 
score < 60 不及格
score >= 60 and score < 80  及格
score >= 80 and score < 90  良好
score >= 90 and score < 100 优秀
score > 100 or score <0 成绩错误
*/
    delimiter $$
    CREATE PROCEDURE proc11 (IN score INT)
    BEGIN
      IF score < 60 
      and score >=0
      THEN
        SELECT
          '不及格';
      ELSEIF score >= 60
        AND score < 80 THEN
        SELECT
          '及格';
      ELSEIF score >= 80
        AND score < 90 THEN
        SELECT
          '良好';
      ELSEIF score >= 90
        AND score <= 100 THEN
        SELECT
          '优秀';
      ELSE
        SELECT
          '成绩错误';
      END IF;
    END $$
    delimiter;

set @score = -6;
call proc11(@score);



-- 输入员工名字 判断工资情况
/*
sal < 10000 试用薪资
sal < 20000 转正薪资
sal > 20000 元老薪资
*/
      delimiter $$
      CREATE PROCEDURE proc12 (IN param_ename VARCHAR (20))
      BEGIN
        DECLARE
        var_sal DECIMAL (10, 2);
        SELECT
          sal INTO var_sal
        FROM
          emp
        WHERE
          ename = param_ename;
        IF var_sal < 10000 THEN
          SELECT
            '试用薪资' AS sal_condition;
        ELSEIF var_sal >= 10000
          AND var_sal < 20000 THEN
          SELECT
            '转正薪资' AS sal_condition;
        ELSE
          SELECT
            '元老薪资' AS sal_condition;
    end if ;
    end $$ 
    delimiter ;

call proc12('关羽');




      delimiter $$
      CREATE PROCEDURE proc13 (IN param_ename VARCHAR (20))
      BEGIN
        DECLARE var_sal DECIMAL (10, 2);
        declare result varchar(20);
        SELECT
          sal INTO var_sal
        FROM
          emp
        WHERE
          ename = param_ename;
        IF var_sal < 10000 THEN
          set result = '试用薪资';
        ELSEIF var_sal >= 10000
          AND var_sal < 20000 THEN
          set result = '转正薪资';
        ELSE
          set result = '元老薪资';
    end if ;
    select result ;
    end $$ 
    delimiter ;
    
CALL proc13('谢逊');
call proc13('程普');


-- 另一种条件判断的控制语句 case
delimiter $$
create procedure proc14(in pay_type int)
BEGIN
  case pay_type 
    when 1 then select '微信支付' as way ;
    when 2 then select '支付宝支付' as way;
    when 3 then select '银行卡支付' as way ;
    else select '其他支付' as way;
    end case ;
end $$
delimiter ;

CALL proc14(2);
CALL proc14(4);

delimiter $$
create procedure proc15(in pay_type int)
BEGIN
declare result varchar(20);
case pay_type 
    when 1 then set result = '微信支付';
    when 2 then set result = '支付宝支付';
    when 3 then set result = '银行卡支付';
    else set result = '其他支付';
    end case ;
    select result ;
    end $$
delimiter ;

call proc15(1);
  
  

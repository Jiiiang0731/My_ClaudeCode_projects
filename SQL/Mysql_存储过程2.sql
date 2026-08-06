USE mydb5;
-- 循环
-- 循环是一段在程序中只出现一次,但是可能会连续运行多次的代码
-- 循环中的代码会运行特定的次数,或者是运行到特定的条件成立时结束循环
-- while
-- repeat
-- loop
-- leave类似于break 跳出当前循环
-- iterate 类似于continue 继续,仅结束本次循环,继续下一次循环
-- [标签] while 循环条件 do
--     循环体;
-- end while;
-- 向表中循环添加指定数量的数据
CREATE TABLE USER(uid INT PRIMARY KEY, username VARCHAR (20), PASSWORD VARCHAR (20))
-- while
delimiter $$
CREATE PROCEDURE proc16_while (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 1;
  label :
  WHILE i <= insertCount DO
    INSERT INTO USER(uid, username, PASSWORD)
    VALUES
    (i, concat('_', 'user', i), '123456');
    SET i = i + 1;
  END WHILE label;
END $$
delimiter;
CALL proc16_while (10);
SELECT
  *
FROM
  USER;
-- while + iterate
DROP TABLE user2;
CREATE TABLE user2 (uid INT, username VARCHAR (20), PASSWORD VARCHAR (20)) TRUNCATE TABLE user2;
delimiter $$
CREATE PROCEDURE proc18_while (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 1;
  label :
  WHILE i <= insertCount DO
    INSERT INTO user2
    VALUES
    (i, concat('_', 'user', i), '123456');
    IF i = 5 THEN
      ITERATE label; -- 当i=5时循环会在这个地方卡住,不会再正常的执行后面的语句,进入死循环
    END IF;
    SET i = i + 1;
  END WHILE;
  SELECT
    *
  FROM
    user2;
END $$
delimiter;
CALL proc18_while (10);
SELECT
  count(1)
FROM
  user2;
delimiter $$
CREATE PROCEDURE proc19_while (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 0;
  label :
  WHILE i < insertCount DO
    SET i = i + 1;
    IF i = 5 THEN
      ITERATE label;
    END IF;
    INSERT INTO user2
    VALUES
    (i, concat('_', 'user', i), '123456');
  END WHILE;
  SELECT
    *
  FROM
    user2;
END $$
delimiter;
TRUNCATE TABLE user2;
CALL proc19_while (10);

-- while + leave
TRUNCATE TABLE USER;
delimiter $$
CREATE PROCEDURE proc17_while (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 1;
  label :
  WHILE i <= insertCount DO
    INSERT INTO USER
    VALUES
    (i, concat('_', 'user', i), '123456');
    IF i = 5 THEN
      LEAVE label;
    END IF;
    SET i = i + 1;
  END WHILE label;
  SELECT
    *
  FROM
    USER;
END $$
delimiter;
CALL proc17_while (10);
-- 循环 repeat
-- [标签]: repeat
-- 循环体
-- until 条件表达式
-- end repeat [标签]
TRUNCATE TABLE USER;
delimiter $$
CREATE PROCEDURE proc20_repeat (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 1;
  label :
  REPEAT
    INSERT INTO USER
    VALUES
    (i, concat('_', 'user', i), '123456');
    SET i = i + 1;
  UNTIL i > insertCount
  END REPEAT label;
  SELECT
    *
  FROM
    USER;
END $$
delimiter;
CALL proc20_repeat (10);
-- 循环 loop
-- [标签:] loop
-- 循环体
-- if 条件表达式 THEN
-- leave [标签:]
-- end if
-- end loop;
TRUNCATE TABLE USER;
delimiter $$
CREATE PROCEDURE proc21_loop (IN insertCount INT)
BEGIN
  DECLARE
  i INT DEFAULT 1;
  label :
  LOOP
    INSERT INTO USER
    VALUES
    (i, concat('_', 'user', i), '123456');
    SET i = i + 1;
    IF i > insertCount THEN
      LEAVE label;
    END IF;
  END LOOP;
  SELECT
    *
  FROM
    USER;
END $$
delimiter;
CALL proc21_loop (20);
-- 游标cursor
-- 游标是用来存储查询结果集的数据类型,再存储过程和函数中可以使用光标对结果集进行循环的处理. 光标的使用包括光标的声明 open fetch close.
-- cursor声明
-- declare cursor_name cursor for select_statement
USE mydb5;
DROP PROCEDURE
IF EXISTS proc22_cursor;
  -- 输入一个部门名称  查询该部门员工的编号,员工的名字 和员工的薪资
  -- 将查询的结果集添加游标
  delimiter $$
  CREATE PROCEDURE proc22_cursor (IN in_dname VARCHAR (50))
  BEGIN
    -- 定义局部变量
    DECLARE
    param_empno INT;
    DECLARE
    param_ename VARCHAR (20);
    DECLARE
    param_sal DECIMAL (10, 2);
    -- cursor打开
    -- open cursor_name
    DECLARE
    my_cursor CURSOR FOR SELECT
        empno,
        ename,
        sal
      FROM
        emp AS t1
        INNER JOIN dept AS t2 ON t1.deptno = t2.deptno
      WHERE
        t2.dname = in_dname;
      OPEN my_cursor;
      -- cursor取值
      -- fetch cursor_name into var_name,var_name...
      -- 单独写fetch语句一次只会得到一行数据 如果想要得到多行数据就得使用循环
      label :
      LOOP
      FETCH my_cursor INTO param_empno,
      param_ename,
      param_sal;
      SELECT
        param_empno,
        param_ename,
        param_sal;
    END LOOP label;
    -- 通过循环来fetch的问题在于他会一直循环直到报错'no data'
    -- cursor关闭
    -- close cursor_name
    CLOSE my_cursor;
  END $$
  delimiter;
  CALL proc22_cursor ('销售部');
  -- 异常处理 handler 句柄
  -- Mysql存储过程也提供了过异常处理的功能:通过定义handler来完成异常声明的实现
  delimiter $$
  CREATE PROCEDURE proc23_cursor (IN in_dname VARCHAR (50))
  BEGIN
    DECLARE
    param_empno INT;
    DECLARE
    param_ename VARCHAR (20);
    DECLARE
    param_sal DECIMAL (10, 2);
    -- 定义标记值 来控制loop下面select语句是否执行
    DECLARE
    flag INT DEFAULT 1;
    DECLARE
    my_cursor CURSOR FOR SELECT
        empno,
        ename,
        sal
      FROM
        emp AS t1
        INNER JOIN dept AS t2 ON t1.deptno = t2.deptno
      WHERE
        t2.dname = in_dname;
      /*
      在打开游标之前定义handler 定义异常的处理方式
      1.异常处理结束之后程序应该怎样执行
      continue 继续执行剩下的程序代码
      exit 直接终止程序的运行
      undo -- 在官方文档中undo的解释为 not supported,所以undo在sql中不支持使用
      2. 触发条件
      mysql _error_code
      SQlstate|value|sqlstate_value
      condition_name
      SQLWARNING
      NOT FOUND
      SQLEXPECTION
      3.触发异常之后执行什么代码
      设置flag的值 ---> 0
      */
      DECLARE
      CONTINUE HANDLER FOR 1329
        SET flag = 0; -- NOT FOUNG也可以
        OPEN my_cursor;
        label :
        LOOP
        FETCH my_cursor INTO param_empno,
        param_ename,
        param_sal;
        -- 判断标记位 flag 如果flag为1就执行 否则不执行
        IF flag = 1 THEN
          SELECT
            param_empno,
            param_ename,
            param_sal;
        ELSE
          LEAVE label;
        END IF;
      END LOOP label;
    END $$
    delimiter;
    CALL proc23_cursor ('销售部');
    -- 循环构建table 按照日期顺序构建下个月一号到最后一天的所有表
    USE mydb5;
    DROP PROCEDURE
    IF EXISTS exercise;
      delimiter $$
      CREATE PROCEDURE exercise ()
      BEGIN
        DECLARE
        next_month INT; -- 下一个月
        DECLARE
        next_year INT; -- 下一个月的年份
        DECLARE
        next_month_day INT; -- 下一个月对应的天
        DECLARE
        next_month_str VARCHAR (2); -- 下一个月的月份字符串
        DECLARE
        next_month_day_str VARCHAR (2); -- 下一个月的天的字符串
        DECLARE
        table_name_time_str VARCHAR (10); -- 处理每天的表名
        DECLARE
        t_index INT DEFAULT 1;
        SET next_year = YEAR(date_add(now(), INTERVAL 1 MONTH));
        SET next_month = MONTH(date_add(now(), INTERVAL 1 MONTH));
        SET next_month_day = dayofmonth(LAST_DAY(date_add(now(), INTERVAL 1 MONTH)));
        IF next_month < 10 THEN
          SET next_month_str = concat('0', next_month);
        ELSE
          SET next_month_str = concat('', next_month);
        END IF;
        WHILE t_index <= next_month_day DO
          IF t_index < 10 THEN
            SET next_month_day_str = concat('0', t_index);
          ELSE
            SET next_month_day_str = concat('', t_index);
          END IF;
          SET table_name_time_str = concat(next_year, '_', next_month_str, '_', next_month_day_str);
          SET @create_table_name = concat ('create table user_', table_name_time_str, '(uid int, uname varchar(20), information varchar(50)) collate=\'utf8_general_ci\' engine=InnoDB');
          -- 对拼接的创建语句进行提前的预处理
          -- from后面不可以使用局部变量
          PREPARE create_table_stmt
          FROM
            @create_table_name;
          EXECUTE create_table_stmt;
          DEALLOCATE PREPARE create_table_stmt;
          SET t_index = t_index + 1;
        END WHILE;
      END $$
      delimiter;
      CALL exercise ();
      SHOW TABLES;
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      USE mydb5;
      DROP PROCEDURE
      IF EXISTS re_try;
        delimiter $$
        CREATE PROCEDURE re_try ()
        BEGIN
          DECLARE
          next_year INT;
          DECLARE
          next_month INT;
          DECLARE
          next_lastday INT;
          DECLARE
          next_month_str VARCHAR (2);
          DECLARE
          next_month_day_str VARCHAR (2);
          DECLARE
          table_name_time_str VARCHAR (20);
          DECLARE
          d_index INT DEFAULT 1;
          SET next_year = YEAR(date_add(now(), INTERVAL 1 MONTH));
          SET next_month = MONTH(date_add(now(), INTERVAL 1 MONTH));
          SET next_lastday = dayofmonth(last_day(date_add(now(), INTERVAL 1 MONTH)));
          IF next_month < 10 THEN
            SET next_month_str = concat('0', next_month);
          ELSE
            SET next_month_str = concat('', next_mopnth);
          END IF;
          WHILE d_index <= next_lastday DO
            IF d_index < 10 THEN
              SET next_month_day_str = concat('0', d_index);
            ELSE
              SET next_month_day_str = concat('', d_index);
            END IF;
            SET table_name_time_str = concat(next_year, '_', next_month_str, '_', next_month_day_str);
            SET @create_table_name = concat('create table user_', table_name_time_str, '(uid int, uname varchar(20), information varchar(50), password varchar(15)) collate=\'utf8_general_ci\' engine=InnoDB');
            PREPARE create_table_stmt
            FROM
              @create_table_name;
            EXECUTE create_table_stmt;
            DEALLOCATE PREPARE create_table_stmt;
            SET d_index = d_index + 1;
          END WHILE;
          SHOW TABLES;
        END $$
        delimiter;
        CALL re_try ();
        
    
        



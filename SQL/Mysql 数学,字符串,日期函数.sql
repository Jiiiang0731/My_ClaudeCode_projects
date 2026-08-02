create database mydb3;
use mydb3;
create table emp (
emp_id int primary key auto_increment comment '编号',
emp_name varchar(20) not null default '' comment '姓名',
salary decimal(10,2) not null default 0 comment '工资',
department varchar(20) not null default '' comment '部门'
);
insert into emp(emp_name,salary,department)
values 
('张晶晶',5000,'财务部'),
('王飞飞',5800,'财务部'),
('赵刚',6200,'财务部'),
('刘小贝',5700,'人事部'),
('王大鹏',6700,'人事部'),
('张小斐',5200,'人事部'),
('刘云云',7500,'销售部'),
('刘云鹏',7200,'销售部'),
('刘云鹏',7800,'销售部');
 
-- 聚合函数 group_concat()
-- select 字段,group_concat(row_ order by row_ asc/desc SEPARATOR '分隔符')
-- from table_name group by 所有非聚合字段;
-- 将所有员工的数据合并成一行
select group_concat(emp_name) from emp;
-- 指定分割符合并
select group_concat(emp_name separator ' ; ') from emp;
-- 指定排序方式和分割发符
select department , group_concat(emp_name separator ' ; ')
from emp
group by department  -- 按照部门对员工进行分组
;

select department , group_concat(emp_name order by salary desc separator ' ; ')
from emp group by department  ;



-- 数学函数
-- abs() 得到绝对值
select abs(-10);
-- select abs(字段/表达式) from table_name


-- ceil() 向上取整 返回比它更大的最小整数
select ceil(1.1);  -- 2 
select ceil(1); -- 1
select ceil(-1.1); -- -1
-- floor() 向下取整 返回比它小的最大整数
select floor(1.1);
select floor(1.9);
select floor(-1.1); -- -2

-- greatest(expr1,expr2...) 返回列表中的最大值
select greatest(1,2,3,4,5) ;

-- least(expr1,expr2...) 返回列表中的最小值
select least(1,2,3,4,5) ;

-- max(不能是列表,这里必须是字段或表达式)
select max(salary) from emp;

-- min()
select min(salary) from emp;

-- mod(x,y) 取x / y的余数
select mod(28,27);

-- pi() 返回圆周率 3.141593
select pi();
select 100 * pi() As area ;

-- pow(x,y) 返回x的y次方
select pow(2,10);

-- rand() 返回0-1 之间的随机数
select rand() ;
select floor(rand() * 100);

-- round(x) 返回离x最近的整数,遵循四舍五入原则
select round(1234.7234);
select round(rand()* 100);
select round(rand()* 100,0);

select category_id,round(avg(price)) 
from mydb1.example group by category_id;

-- round(x,y) 返回指定位数的小数 遵循四舍五入原则
select round(1234.234678,5);

-- truncate(x,y) 返回数值x保留到小数点后y位的值,但是不会进行四舍五入
select truncate(83456.48456,4); 


-- 字符串函数
-- char_length(s)   返回字符串s的字符数
select char_length(emp_name) from emp;
-- character_length(s) 返回字符串s的字符数
SELECT char_length('hello');
select char_length('你好')
-- length()函数
select length('hello');
select length('你好啊'); -- length()取长度返回的单位是字节,utf8一个汉字占三个字节


-- concat(s1,s2,s3...) 将字符串s1,s2等多个字符串合并成一个字符串
select concat('hello','world');

-- concat_ws(x,s1,s2...sn) 同concat(),但该函数会在每个字符串之间加上x,x为分隔符
select concat_ws(' ','hello','world');

-- field(s,s1,s2...) 返回第一个字符串s在字符串列表s1,s2..中的位置
SELECT field('hello','nnn','mmm','world','hello');

-- ltrim(s) 去掉字符串s左边所有的空格
select ltrim('  I am who I am');
-- rtrim(s) 去掉字符串s右边的所有空格
select rtrim(' something you can do    ');
-- trim() 去掉字符串左右两边的所有空格
select trim('     This is just an example       ');

-- mid(s,n,len) 从字符串s的n位置开始截取长度为len的字符串 同substring(s,n,len)
select mid('The world will be cultivated flowers because of me',5,32);
select substring('I will go forward',8,10);
-- position(s1 in s) 从字符串的s中获取s1的开始位置
select position('am' in 'who i am,ive ever know');

-- replace(s,s1,s2) 将字符串s2代替字符串s中的字符串s1
select replace('aaaabcaa','a','s');

-- reverse(s) 将字符串s的顺序反过来
select reverse('uoy evol i');

-- right(s,n) 返回字符串s的后n个字符
select right('dont be afraid of anything',8);

-- strcmp(s1,s2) 比较字符串s1和s2 如果相等返回0,如果是s1>s2返回1,如果s1<s2返回-1
select strcmp('storm','storm');
select strcmp('crazy','quiet');
select strcmp('棍','滚');
-- 从每个单词的第一个字母开始,比较两个字母ascii中的编码位置,直到比出胜负
-- 汉字的比较遵循当前的校对规则决定,默认是按Unicode(康熙字典顺序)进行检索

-- substr(s,start,length) 从字符串s的start位置开始截取长度为length的子字符串
-- mid(s,n,len) = sbustring(s,n,len) = substr(s,start,length)
select substr('cause you never leave me out',17,12);

-- upper(s) and ucase(s) 将字符串的所有字母转成大写
select upper('asdfghjkl');
select ucase('asdfghjkl');

-- lcase(s) and lower(s) 将字符串的所有字母转成小写
select lcase('ASDFGHJKL');
SELECT LOWER('ASDFGHJKL');

-- UNIX_TIMESTAMP() 
-- 返回从1970-01-01 00:00:00(格林尼治标准时间) 到当前时刻过了多少秒
select unix_timestamp();

-- unix_timestamp(date_string) 将指定日期转为毫秒值时间戳
select unix_timestamp('2007-07-31 04:30:00');
select unix_timestamp('1970-01-01 08:00:01');
-- from_unixtime(bigint unixtime,[string format])
select from_unixtime(1185827400,'%Y-%m-%d %H:%i:%s');

-- curdate() = current_date() 返回当前日期
select curdate();
select current_date();

-- 获取当前的时分秒
select current_time();
select curtime();

-- 获取年月日时分秒
select current_timestamp();

-- date() 从日期或日期时间表达式中提取日期值 年月日
select date('2007-07-31 04:30:00')

-- datediff(d1,d2) 计算日期d1 > d2之间相隔的天数
select datediff('2007-01-16','2007-07-31');
select datediff(current_date(),'2007-07-31')

-- timediff(time1,time2) 计算时间差值
select timediff('04:24:36','07:49:43');

-- date_format(d,f) 按表达式f的样式要求显示日期d
select date_format('2011-11-11 04:30:00','%Y-%m-%d %r')

-- str_to_date(string,format_mask) 将字符串转换成日期
select str_to_date('August 10 2017','%M %d %Y');

-- date_sub(date,interval expr type) 函数从日期减去指定的时间间隔
select date_sub(current_date(),interval 520 day);

-- date_add(date,interval expr type) 函数从日期加上指定的时间间隔
select date_add(current_date(),interval '2-3' year_month);
select date_add(current_date(),interval '3 5' day_hour);
select date_add(current_date(),interval '5 50' day_minute); 

-- extract(type from d) 从日期d中获取指定的值,type指定返回的值
-- type: microsecond,second,minute,hour
select extract(hour from '2007-07-31 04:30:00');
select extract(minute from '2007-07-31 04:30:00');
select extract(microsecond from '2007-07-31 04:30:00');

-- last_day(d) 返回给定日期那个月的最后一天
select last_day('2008-02-01');

-- MAKEDATE(YEAR(date),dayofyear) 
-- 基于给定参数年份year和所在年中的天数序号day-of-year返回一个日期
select makedate('2007',212);

-- 根据日期获取年月日时分秒
select year('2007-07-31');
select hour('2007-07-31 23:33:32');
select month('2007-07-31');
select quarter('2007-07-31 02:33:32');  -- 获取月份所在年的季度

-- monthname()
select monthname('2007-07-31 02:33:32');

-- dayname()
select dayname('2007-08-02 02:33:32');

-- dayofmonth()
select dayofmonth('2007-07-31 02:33:32');

-- dayofweek()  
select dayofweek('2007-07-31 02:33:32');

-- dayofyear()
select dayofyear('2007-07-31 07:33:32');

-- week(d)  -- 输出给定参数是这一年的第几个周 0-53
-- weekofyear(d)  -- 同上
select week('2007-07-31 07:33:32');
select weekofyear('2007-07-31 07:33:32');
select week('2007-01-01 07:33:32')
-- weekday(d)  -- 输出该日期是这个周的第几天,星期一为0,星期二为1...
select weekday('2007-07-31 07:33:32');

-- yearweek(date,mode); 返回年份及第几周 mode中0表示周日,1表示周一...
select yearweek('2007-07-31 07:33:32')

-- now 返回当前的日期和时间
select now();
select CURRENT_timestamp();
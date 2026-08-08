/*
再Mysql中的事务(Transaction)是由存储引擎实现的 在Mysql中只有InnoDB存储引擎才支持事务
事务处理可以用来围护数据库的完整性 保证成批的sql语句 要么全部执行 要么全部不执行
事务用来管理DDL DML DCL等操作 比如insert update delete语句 默认是自动提交的  
*/
-- 以下代码如果只有第一句成功执行但是第二句话没有执行那么在真实的银行系统中
-- 就会出现一方扣钱但是收款方没有收到汇款的情况 这个时候如果用事务将这两个代码绑定
-- 必须两条代码都执行成功才算执行成功 这就是事务的作用
update bank set  money = money - 200 where id = 1;
update bank set  money = money + 200 where id = 2;

-- Mysq的事务操作主要有三种
/*
1. 开启事务 start transaction
	任何一条DML语句IDU的执行 都标志着事务的开启 命令: begin/start transaction
2. 提交事务 commit transaction
	成功的结束 将所有的DML语句操作历史记录和底层硬盘数据来一次同步 命令:commit\
3. 回滚事务 rollback transaction
	失败的结束 将所有的DML语句操作历史记录全部清空 命令:rollback
*/
-- 之前的所有SQL操作其实也有事务 只是SQL自动帮我们完成的 每执行一条SQL时Mysql会自动提交事务
-- 所以我们如果想要手动控制事务的话需要先将MYSQL的事务自动提交关闭
set autocommit = 0 ; -- 禁止自动提交
set autocommit = 1 ; -- 开启自动提交

set autocommit = 0 ;
select @@autocommit;
-- 开启事务
-- 注意在开启事务之后再次单独运行SQL时只会在内存中运行 但是数据不会在硬盘中改变 需要提交事务
start transaction;
update bank set  money = money - 200 where id = 1;
update bank set  money = money + 200 where id = 2;
-- 提交事务
-- 提交和回滚二选一 
-- 提交之后数据会永久改变
commit;
-- 回滚事务(在执行失败的情况下运行)
-- 会将之前的操作全部撤销
rollback;

select * from bank;

-- 事务的特性
/*
1. 原子性: 事务是一个不可再分的整体 事务开始之后的所有操作 要么全部完成,要么全部不完成
2. 一致性: 系统从一个正确的 状态迁移到另一个正确的状态
3. 隔离性: 每个事务的对象对其他事务的操作对象互相分离 事务提交前对其他事务不可见
4. 持久性: 事务一旦提交 则其结果是永久的 
*/

-- 事务的隔离级别 
-- isolate 顾名思义就是将事务与另一个事务隔离开 
-- 因为又可能存在多个事务同时操作同一张表的情况 所以需要隔离多个事务避免相互影响从而干扰执行效果
/*
1. 读未提交(read uncommitted)
	一个事务可以读取另一个未提交事务的数据 最低级别 任何情况都无法保证 会造成脏读
2. 读已提交(read committed) default in Oracle
	一个事务要等另一个事务提交后才能读取数据,可以避免脏读,会造成不可重复读
3. 可重复读(repeatable read) default in MYSQL
	就是在开始读取数据(事务开启)时 不再允许修改操作 可以避免脏读 不可重复读发生 但是会造成幻读
4. 串行(serializable)
	是最高的事务隔离级别 在该级别下 事务串行化顺序执行 可以避免脏读 不可重复读 不可重复读与
   串读 但是这种事务隔离级别效率低下 比较消耗数据库性能 一般不使用
*/

-- 结合锁机制可以解决repeatable read的一些问题
begin;
update bank set money = money + 200 where name = 'zhangsan';
update bank set money = money - 200 where name = 'lisi';

commit;

-- 查看隔离级别
show variables like '%isolation%';
-- 设置隔离级别
set session transaction isolation level x;


-- 设置read uncommitted 
-- 脏读会读取到另一个事务没有提交的数据而造成一定的影响
set session transaction isolation level read uncommitted;


-- 设置read committed
-- 不可重复读就是在同一事务中如果另一事务提交,那么对同一个数据的读取可能会不同
set session transaction isolation level read committed ;


-- 设置repeatable read 
-- 幻读/可重复读需要自己提交一次才可以看见改变之后的数据,但是缺点就是在提交前后看到的数据不一致
set session transaction isolation level repeatable read;


-- 设置serializable 
-- 这种方式会在一个事务没有提交但是另一个事务进行DML时会将后操作的表进行锁表,直到前表提交
set session transaction isolation level serializable; 
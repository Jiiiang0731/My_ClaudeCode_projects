use itcast_shop ;

-- 创建临时表
create temporary table tmp_goods_cat 
AS 
select t3.catid as cat_id_l3,  -- 三级分类
       t3.catname as cat_name_l3,
       t2.catid as cat_id_l2,  -- 二级分类
       t1.catid as cat_id_l1,  -- 一级分类
       t1.catname as cat_name_l1
from itcast_shop.itheima_goods_cats t3,
     itcast_shop.itheima_goods_cats t2,
     itcast_shop.itheima_goods_cats t1 
where t3.parentid = t2.catid 
  and t2.parentid = t1.catid 
  and t3.cat_level = 3;
  
select * from tmp_goods_cat;

-- 统计分析不同一级商品分类对应的总金额  总比数
select 
    '2019-09-05' as time ,
    t1.cat_name_l1 as good_cat_l1 , 
    sum(t3.payprice * t3.goodsnum) as total_money ,
    count(distinct t3.orderid ) as total_cnt 
from 
    tmp_goods_cat t1 
left join itheima_goods t2 
  on t1.cat_id_l3 = t2.goodscatid 
left join itheima_order_goods t3 
  on t2.goodsid = t3.goodsid 
where 
  substring(t3.createtime,1,10) = '2019-09-05'
group by 
  t1.cat_name_l1 ;
  
  
-- 添加索引测试是否索引会加快查询的速度 0.252 --> 0.062
drop index idx_itheima_goods on itheima_goods;
drop index idx_itheima_order_goods on itheima_order_goods;

create unique index idx_goods_cat3 on tmp_goods_cat(cat_id_l3);
create index idx_itheima_goods on itheima_goods(goodscatid);
create unique index idx_itheima_goodsid on itheima_goods(goodsid);
create index idx_itheima_order_goods on itheima_order_goods(goodsid);
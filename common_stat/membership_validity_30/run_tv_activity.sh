source /etc/profile;
source ~/.bash_profile;
BASEDIR=`dirname $0`
cd $BASEDIR


sdate=`date -d "1 days ago" +"%Y-%m-%d"`

if [ "$#" -eq 1 ]; then
  sdate=$1
fi

ssdate=${sdate//-/}

hive -e "select count(distinct case when ilu='0' then uid end),count(distinct case when ilu='0' then id end),count(distinct id),'tv_all',${ssdate} from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv'
" > ./data/tv_activity_user.${ssdate}

hive -e "select count(distinct case when ilu='0' then uid end),count(distinct case when ilu='0' then id end),count(distinct id),'tv_21',${ssdate} from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv'  and p2='21'" > ./data/tv21_activity_user.${ssdate}


hive -e"
select tt1.canceldate,tt1.tv_uv,tt2.pay_uv,tt2.pay_money,tt2.all_cnt,tt2.order_cnt,tt3.userNum,${ssdate} from
(select t1.canceldate,count(distinct t1.userid) as tv_uv from
(select userid,case when datediff(max(canceltime),'${sdate}')<30 then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and canceltime>='${sdate}' and dt<='${ssdate}' and viptype='9' group by userid) t1
join
(select uid from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv' and ilu='0')t2
on(t1.userid=t2.uid)
group by t1.canceldate)tt1
LEFT JOIN
(select sum(case when t3.order_cnt>0 then 1 else 0 end) as pay_uv,sum(t3.money) as pay_money,sum(t3.order_cnt) as order_cnt,sum(t3.all_cnt) as all_cnt,t1.canceldate from 
(select userid,max(canceltime) as canceltime,case when datediff(max(canceltime),'${sdate}')<30 or max(paytime)='${sdate}' then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 and max(paytime)!='${sdate}'  then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and viptype='9' and orderpaytype='2' and (paytime!='${sdate}' or (neworxufei=0 and paytime='${sdate}')) and canceltime>='${sdate}' and dt<='${ssdate}' group by userid)t1
join
(select distinct uid from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv' and ilu='0')t2
on(t1.userid=t2.uid)
join 
(select userid,sum(case when status=1 then money else 0 end) as money,sum(case when status= 1 then 1 else 0 end) as order_cnt,count(orderid) as all_cnt from dm_boss.t_new_order_4_data where  ordertype!='1001' and viptype='9' and dt='${ssdate}' group by userid) t3
on(t1.userid=t3.userid)
group by t1.canceldate)tt2
on(tt1.canceldate=tt2.canceldate)
LEFT JOIN
(select count(t1.userid) as userNum,canceldate from 
(select userid,case when datediff(max(canceltime),'${sdate}')<30 then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and canceltime>='${sdate}' and dt<='${ssdate}' and viptype='9' group by userid)t1
group by t1.canceldate)tt3
on(tt1.canceldate=tt3.canceldate)
" > ./data/tv_order_user.${ssdate}

hive -e"
select tt1.canceldate,tt1.tv_uv,tt2.pay_uv,tt2.pay_money,tt2.all_cnt,tt2.order_cnt,tt3.userNum,${ssdate} from
(select t1.canceldate,count(distinct t1.userid) as tv_uv from
(select userid,case when datediff(max(canceltime),'${sdate}')<30 then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and canceltime>='${sdate}' and dt<='${ssdate}' and viptype='9' group by userid) t1
join
(select uid from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv' and p2='21' and ilu='0')t2
on(t1.userid=t2.uid)
group by t1.canceldate)tt1
LEFT JOIN
(select sum(case when t3.order_cnt>0 then 1 else 0 end) as pay_uv,sum(t3.money) as pay_money,sum(t3.order_cnt) as order_cnt,sum(t3.all_cnt) as all_cnt,t1.canceldate from
(select userid,max(canceltime) as canceltime,case when datediff(max(canceltime),'${sdate}')<30 or max(paytime)='${sdate}' then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 and max(paytime)!='${sdate}'  then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and viptype='9' and orderpaytype='2' and (paytime!='${sdate}' or (neworxufei=0 and paytime='${sdate}')) and canceltime>='${sdate}' and dt<='${ssdate}' group by userid)t1
join
(select distinct uid from data_sum.sum_user_pv_day where dt='${ssdate}' and product='tv' and p2='21' and ilu='0')t2
on(t1.userid=t2.uid)
join
(select userid,sum(case when status=1 then money else 0 end) as money,sum(case when status= 1 then 1 else 0 end) as order_cnt,count(orderid) as all_cnt from dm_boss.t_new_order_4_data where  ordertype!='1001' and viptype='9' and dt='${ssdate}' group by userid) t3
on(t1.userid=t3.userid)
group by t1.canceldate)tt2
on(tt1.canceldate=tt2.canceldate)
LEFT JOIN
(select count(t1.userid) as userNum,canceldate from
(select userid,case when datediff(max(canceltime),'${sdate}')<30 then 'lt30' when datediff(max(canceltime),'${sdate}')>=30 then 'gt30' end as canceldate from dm_boss.t_new_order_4_data where status=1 and ordertype!='1001' and canceltime>='${sdate}' and dt<='${ssdate}' and viptype='9' group by userid)t1
group by t1.canceldate)tt3
on(tt1.canceldate=tt3.canceldate)
" > ./data/tv21_order_user.${ssdate}

#!/bin/bash
#该脚本用来导入院线会员表t_vip_product_order到hive中
source ~/.bashrc
BASEDIR=`dirname $0`
cd $BASEDIR

yesterday=`date -d "1 days ago" +"%Y%m%d"`
if [ $# -eq 1 ]; then
	yesterday=$1
fi

today=`date -d "${yesterday} +1 day" +"%Y%m%d"`

log_path=./logs/t_vip_product_order_${yesterday}.log

echo "开始导入${yesterday}~${today}日的数据到hive中" > $log_path

db_ip=10.183.196.100     #源数据库IP
db_port=3306            #源数据库端口 
db_user=boss_stat_w       #源数据库用户名
db_pass=6b9b3#2137F     #源数据库密码
db_name=boss_stat         #源数据库名称

file=`pwd`/data/t_letv_vip_order_all_${yesterday}.csv

columns="orderid,order_name,user_id,selling_price,deductions,pay_price,user_ip,success_time,create_time,start_time,end_time,pay_channel,pay_channel_desc,pay_merchant_business_id,business_id,is_refund,product_type,
product_subtype,product_id,product_name,product_duration,product_duration_type,pay_orderid,package_id,is_renew,subscribe_package_id,subscribe_price,terminal,app_product_id,tax_code,tax,REPLACE(SUBSTR(order_desc, 2, CHAR_LENGTH(order_desc) - 2), '\"', ''),
present_channel,order_flag,parent_channel,cps_id,p1,p2,p3,coupon,coupon_batch,card_id,card_batch,activity_id,deviceid,device_brand,device_model,order_src,ref,status,is_new,version,country,platform"

#从mysql查询结果导入到文件中
mysql -N --default-character-set=utf8 -h ${db_ip} -P ${db_port} -u ${db_user} -p${db_pass} ${db_name} -e "SELECT ${columns} from t_letv_vip_order_all where create_time>='${yesterday}' and create_time<'${today}'" > ${file}

echo "从数据库查询数据结束，文件名为${file}" >> $log_path

#将文件导入hive表中，覆盖存在的分区
hive -e "LOAD DATA LOCAL INPATH '${file}' OVERWRITE INTO TABLE dm_boss.t_letv_vip_order_all PARTITION (dt='${yesterday}')"

echo "导入${file}到hive完成" >> $log_path


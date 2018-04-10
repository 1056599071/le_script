#!/bin/bash

echo "开始创建表t_letv_vip_order_all..."
hive -e "CREATE TABLE IF NOT EXISTS dm_boss.t_letv_vip_order_all (
	orderid string COMMENT '产品订单号',
	order_name string COMMENT '产品名称',
	user_id bigint,
	selling_price decimal(11,2) COMMENT '售卖价格',
	deductions decimal(11,2) COMMENT '优惠额-代金券等',
	pay_price decimal(11,2) COMMENT '通道真实支付价格',
	user_ip string COMMENT '购买用户ip',
	success_time string COMMENT '支付成功时间',
	create_time string,
	start_time string,
	end_time string,
	pay_channel int COMMENT '支付系统通道',
	pay_channel_desc string COMMENT '支付系统通道描述',
	pay_merchant_business_id string COMMENT '支付平台商户ID',
	business_id string COMMENT '院线商户ID',
	is_refund tinyint COMMENT '0：未退款，1：已退款',
	product_type int COMMENT 'ALBUMS(1, "专辑"), SCROLLING(2, "轮播台"), VIDEO(3, "视频"), LIVE_ROUNDS(4, "直播场次"), LIVE_MATCH(5, "赛事"),VIP(100, "会员"),  LIVE_TICKET(200, "直播票")',
	product_subtype int,
	product_id string COMMENT '产品id',
	product_name string,
	product_duration int COMMENT '购买商品的有效天数',
	product_duration_type tinyint COMMENT '套餐时常单位',
	pay_orderid string COMMENT '用户支付订单号',
	package_id string COMMENT '用户购买产品对应的套餐id',
	is_renew tinyint COMMENT '自扣费标识 0:普通订单 1:订阅订单 2:自动续费订单',
	subscribe_package_id string COMMENT '订阅套餐ID（套餐类型必须是订阅）',
	subscribe_price decimal(11,2),
	terminal string COMMENT '终端',
	app_product_id string COMMENT '第三方商品ID',
	tax_code string COMMENT '计税代码',
	tax decimal(11,2) COMMENT '税金',
	order_desc map<string, int> COMMENT '订单描述信息',
	present_channel int COMMENT '免费赠送渠道',
	order_flag int COMMENT '订单扩展标识',
	parent_channel int COMMENT '父支付渠道，支付渠道的较大分类，如支付宝，微信等',
	cps_id string COMMENT '推广位ID',
	p1 string COMMENT '订单一级来源，天猫京东等',
	p2 string COMMENT '订单二级来源，p1的进一步划分',
	p3 string COMMENT '订单三级来源，p2的进一步划分',
	coupon string COMMENT '代金券ID',
	coupon_batch string COMMENT '代金券批次号',
	card_id string COMMENT '乐卡卡号',
	card_batch string COMMENT '乐卡批次号',
	activity_id int COMMENT '活动ID',
	deviceid string COMMENT '用户购买设备唯一标识码 imei或mac等',
	device_brand string COMMENT '设备品牌',
	device_model string COMMENT '设备型号',
	order_src int COMMENT '1 收银台 2 接口',
	ref string COMMENT '订单来源URL中的参数',
	status tinyint COMMENT '订单状态 0：未支付 1：已支付 2：服务关闭',
	is_new tinyint COMMENT '是否新增 0 新增 1 续费',
	version string COMMENT '版本，来自V1还是V2版本',
	country int,
	platform int COMMENT '来源平台 0:乐视'
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE"
echo "创建表t_letv_vip_order_all完成"

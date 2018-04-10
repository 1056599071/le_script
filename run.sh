sh /home/zhaochunlong/boss_stat/vip_zhibiao/vip_order_tohive/run.sh > /home/zhaochunlong/boss_stat/vip_zhibiao/vip_order_tohive/log.txt
sh /home/zhaochunlong/boss_stat/common_stat/external_channel_stat/run.sh &
sh /home/zhaochunlong/boss_stat/common_stat/inner_channel_stat/run.sh &
sh /home/zhaochunlong/boss_stat/common_stat/movie_outside_channel_stat/run.sh &
sh /home/zhaochunlong/boss_stat/common_stat/mobile_action_stat/run.sh &
sh /home/zhaochunlong/boss_stat/common_stat/movie_income_stat/run.sh &
sh /home/zhaochunlong/boss_stat/vip_zhibiao/crontab/run-zhibiao.sh &
sh /home/zhaochunlong/boss_stat/common_stat/membership_validity_30/run.sh &


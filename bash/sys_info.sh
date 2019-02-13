#!/bin/bash

#nice 使用率：低优先级用户态 CPU 时间，也就是进程的 nice 值被调整为 1-19 之间时的 CPU 时间
echo "-----Cpu 使用情况-----"
echo ""
echo "----用户空间CPU百分比、内核空间CPU百分比、空闲CPU百分比、Nice CPU百分比、等待IO CPU百分比----"
echo "----正在运行进程数、hi 硬中断CPU百分比、软中断CPU百分比----"
echo "----平均负载----"
top -bn 1 -i -c|awk '{if ($1!=PID) print $0; else exit}'

echo ""
echo "----中断情况----"
# 进程上下文、线程上下文、中断上下文
# pidstat -w 可查看各进程每秒上下文切换次数
# cswch:每秒自愿上下文切换的次数  nvcswch:每秒非自愿上下文切换
echo "---- in(每秒CPU的中断次数，包括时钟中断)  cs(每秒上下文切换次数) ----"
# 首次执行结果不准确，要等一秒 -- 待优化
vmstat | awk '{if(NR!=1) print $0}' | awk -F' ' '{print $11,$12}'

echo "----查看各类型软中断运行次数----"
# 系统运行以来累计中断次数
# HI 用于实现bottom half
# TIMER 定时中断
# NET_TX 发送网络数据
# NET_RX 接收网络数据
# TASKLET 用于实现tasklet
# SCHED 内核调度
# RCU RCU锁
# 剩下的待研究
cat /proc/softirqs

echo "----查看各类型硬中断运行次数----"
# 系统运行以来累计中断次数
cat /proc/interrupts

# 内存指标
echo ""
echo ""
echo "-----内存情况-----"
# si 每秒从磁盘读入虚部内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露了
# so 每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上
# /proc/<PID>/smaps 查看该进程每个段的内存使用情况（驻留内存大小、私有内存大小、共享页面大小、匿名页面大小等）
free -m

echo ""
echo ""
echo "-----网络情况-----"
# sar -u 查看CPU使用率
# sar -q 查看平均负载
# sar -r 内存使用情况
# sar -W 查看页面交换状况
sar -n DEV

# 磁盘指标
echo ""
echo ""
echo "-----磁盘读写情况-----"
echo ""
# bi  块设备每秒接收的块数量，这里的块设备是指系统上所有的磁盘和其他块设备
# bo 块设备每秒发送的块数量，例如我们读取文件，bo就要大于0。bi和bo一般都要接近0，不然就是IO过于频繁，需要调整。
# dstat 动态查看磁盘IO读写情况
echo "---- bi(块设备每秒接收的块数量)  bo(块设备每秒发送的块数量)----"
vmstat | awk '{if(NR!=1) print $0}' | awk -F' ' '{print $9,$10}'

#!/bin/bash
#---------------------------------------------------------------------------------
# ˵����Linux������--���ܼ�ؽű� ,��ַ��Դ��http://bbs.51cto.com/thread-937759-1.html
# ��Ҫ���: 01.���cpuϵͳ���� 02. ���cpuʹ���� 03. ��ؽ������� 04. ��ش��̿ռ�
# ���ɵ����ܼ����־ $path/performance_%Y%m%d.log
# 2017.06.25 djp
#---------------------------------------------------------------------------------

path='/tmp/monitor/performance'

#01.���cpuϵͳ����
{ #{{{
    IP=`ifconfig eth0 | grep "inet addr" | cut -f 2 -d ":" | cut -f 1 -d " "`
    cpu_num=`grep -c 'model name' /proc/cpuinfo`
    count_uptime=`uptime |wc -w`
    load_15=`uptime | awk '{print $'$count_uptime'}'`
    average_load=`echo "scale=2;a=$load_15/$cpu_num;if(length(a)==scale(a)) print 0;print a" | bc`  
    average_int=`echo $average_load | cut -f 1 -d "."`  
    load_warn=0.70  
    if [ $average_int -gt 0 ]
    then
        echo "$IP��������������15���ӵ�ƽ������Ϊ$average_load����������ֵ1.0����������������$(date +%Y%m%d/%H:%M:%S)" >>$path/performance_$(date +%Y%m%d).log
        echo "$IP��������������15���ӵ�ƽ������Ϊ$average_load����������ֵ1.0����������������$(date +%Y%m%d/%H:%M:%S)" | mail -s "$IP������ϵͳ�������ظ澯" XXXX@qq.com
    else
        echo "$IP��������������15���ӵ�ƽ������ֵΪ$average_load,��������   $(date +%Y%m%d/%H:%M:%S)">>$path/performance_$(date +%Y%m%d).log
    fi
} #}}}

#02. ���cpuʹ����
{ #{{{
    cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $5}' | cut -f 1 -d "."`  
    if [ $cpu_idle -lt 20 ]
    then

        echo "$IP������cpuʣ��$cpu_idle%,ʹ�����Ѿ�����80%,�뼰ʱ����">>$path/performance_$(date +%Y%m%d).log

        echo "$IP������cpuʣ��$cpu_idle%,ʹ�����Ѿ�����80%,�뼰ʱ��������" | mail -s "$IP������cpu�澯" XXXX@qq.com
    else

        echo
        "$IP������cpuʣ��$cpu_idle%,ʹ��������">>$path/performance_$(date +%Y%m%d).log
    fi
} #}}}

#03. ��ؽ�������
{ #{{{
    swap_total=`free -m | grep Swap | awk '{print  $2}'`
    swap_free=`free -m | grep Swap | awk '{print  $4}'`

    swap_used=`free -m | grep Swap | awk '{print  $3}'`

    if [ $swap_used -ne 0 ]
    then
        swap_per=0`echo "scale=2;$swap_free/$swap_total" | bc`
        swap_warn=0.20
        swap_now=`expr $swap_per \> $swap_warn`
        if [ $swap_now -eq 0 ]
        then
            echo "$IP������swap��������ֻʣ�� $swap_free M δʹ�ã�ʣ�಻��20%��ʹ�����Ѿ�����80%���뼰ʱ����">>$path/performance_$(date +%Y%m%d).log

            echo "$IP������swap��������ֻʣ�� $swap_free M δʹ�ã�ʣ�಻��20%, ʹ�����Ѿ�����80%, �뼰ʱ����" | mail -s "$IP�������ڴ�澯" XXXX@qq.com
        else
            echo "$IP������swap��������ʣ�� $swap_free Mδʹ�ã�ʹ��������">>$path/performance_$(date +%Y%m%d).log
        fi

    else
        echo "$IP��������������δʹ��"  >>$path/performance_$(date +%Y%m%d).log
    fi
} #}}}

#04. ��ش��̿ռ�
{ #{{{
    disk_sda1=`df -h | grep /dev/sda1 | awk '{print $5}' | cut -f 1 -d "%"`
    if [ $disk_sda1 -gt 80 ]
    then
        echo "$IP������ /������ ʹ�����Ѿ�����80%,�뼰ʱ����">>$path/performance_$(date +%Y%m%d).log

        echo "$IP������ /������ ʹ�����Ѿ�����80%,�뼰ʱ���� " | mail -s "$IP������Ӳ�̸澯" XXXX@qq.com
    else
        echo "$IP������ /������ ʹ����Ϊ$disk_sda1%,ʹ��������">>$path/performance_$(date +%Y%m%d).log
    fi

    #��ص�¼�û���
    users=`uptime |awk '{print $6}'`
    if [ $users -gt 2 ]
    then

        echo "$IP�������û����Ѿ��ﵽ$users�����뼰ʱ����">>$path/performance_$(date +%Y%m%d).log

        echo "$IP�������û����Ѿ��ﵽ$users�����뼰ʱ����" | mail -s "$IP�������û���¼���澯" XXXX@qq.com
    else

        echo "$IP��������ǰ��¼�û�Ϊ$users�����������">>$path/performance_$(date +%Y%m%d).log
    fi
    ###############################################################################

} #}}}


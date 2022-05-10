#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请在Root用户下安装该脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
    	cmd="yum"
    fi
else
    echo "这个安装脚本不适合你的系统" && exit 1
fi


installSupervisord(){
		if [ supervisord -v ]; then
			echo "本机已安装Supervisord"
		else
			echo"开始安装Supervisord"
			
			  $cmd update -y
    		if [[ $cmd == "apt-get" ]]; then
      	  $cmd install -y lrzsz git zip unzip curl wget supervisor
      	  service supervisor restart
    		else
       	 $cmd install -y epel-release
       	 $cmd update -y
        	$cmd install -y lrzsz git zip unzip curl wget supervisor
       	 systemctl enable supervisord
       	 service supervisord restart
    		fi
		fi
}

install400T9(){
		installSupervisord()	
    
    if [ -d "/root/miner_Bpools/" ]; then
    	if [ -f "/root/miner_Bpools/Bpools" ]; then
        rm -rf /root/miner_Bpools/Bpools
      fi
    	if [ -f "/root/miner_Bpools/Bpools_MakeWalletyml" ]; then
        rm -rf /root/miner_Bpools/Bpools_MakeWalletyml
      fi
		fi
   
    if [ -f "/root/miner_Bpools/Bpools_MakeWalletyml" ]; then
      rm -rf /root/miner_Bpools/minerProxy400T9
    fi
    
    mkdir "/root/miner_Bpools"
    
    $cmd update -y
    
    wget https://github.com/minerproxys/Bpools/releases/download/Bpools/Bpools_AntiMP_Linux.tar.gz -O /root/Bpools_AntiMP_Linux.tar.gz --no-check-certificate
    tar -zxvf /root/Bpools_AntiMP_Linux.tar.gz -C /root/miner_Bpools

    cd /root/miner_Bpools
    chmod 777 /root/miner_Bpools/Bpools
    chmod 777 /root/miner_Bpools/Bpools_MakeWalletyml
    chmod 777 /root/miner_Bpools/minerProxy400T9
   

    echo "Bpools(作者反水器) 已安裝到/root/miner_Bpools"
    echo "Bpools(作者反水器) 首次配置 wallet.yml 文件"
    ./Bpools_MakeWalletyml
     
    start_write_config
    supervisorctl reload
    supervisorctl stop  minerProxy400T9
    supervisorctl start minerProxy400T9
    
    echo "----------------------------------------------------------------"    
    echo "Bpools 已经加入守护，崩溃、开机，都能自动重启"
    echo "查看守护状态：   supervisorctl status  Bpools"
    echo "重启Bpools程序： supervisorctl restart Bpools"
    echo "启动Bpools程序： supervisorctl start   Bpools"
    echo "关闭Bpools程序： supervisorctl stop    Bpools"
    
    echo "minerProxy400T9 已经加入守护，崩溃、开机，都能自动重启"
    echo "查看守护状态：   supervisorctl status  minerProxy400T9"
    echo "重启minerProxy400T9程序： supervisorctl restart minerProxy400T9"
    echo "启动minerProxy400T9程序： supervisorctl start   minerProxy400T9"
    echo "关闭minerProxy400T9程序： supervisorctl stop    minerProxy400T9"
    echo "---------------------记住上述命令便于操作-----------------------"
    echo "----------------------------------------------------------------"
    
    sleep 2s
    echo ""

    echo "1.请记录以下端口、密码等数据。然后浏览器打开 ip:端口 ，登录Bpools网页查看反抽"
    echo "----------------------------------------------------------------"
    echo "Bpools参数："
    cd /root/miner_Bpools
    cat "/root/miner_Bpools/wallet.yml"
    echo "Bpools 端口、密码、抽水钱包。在这里：  cat /root/miner_Bpools/wallet.yml  "
    
    echo "----------------------------------------------------------------"
    echo "minerProxy400T9 参数："
    cd /root/miner_Bpools/config.yml
    cat "/root/miner_Bpools/config.yml"
    echo ""
    echo "minerProxy400T9 配置在这里：  cat /root/miner_Bpools/config.yml  "
    echo ""
    echo "----------------------------------------------------------------"
    supervisorctl status Bpools
    supervisorctl status minerProxy400T9
}

start_write_config() {
	  installPath="/root/miner_Bpools"
    echo
    echo "开启守护"
    echo
    chmod a+x $installPath/Bpools
    if [ -d "/etc/supervisor/conf/" ]; then
        rm /etc/supervisor/conf/Bpools.conf -f
        echo "[program:Bpools]" >>/etc/supervisor/conf/Bpools.conf
        echo "command=${installPath}/Bpools" >>/etc/supervisor/conf/Bpools.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf/Bpools.conf
        echo "autostart=true" >>/etc/supervisor/conf/Bpools.conf
        echo "autorestart=true" >>/etc/supervisor/conf/Bpools.conf
    elif [ -d "/etc/supervisor/conf.d/" ]; then
        rm /etc/supervisor/conf.d/Bpools.conf -f
        echo "[program:Bpools]" >>/etc/supervisor/conf.d/Bpools.conf
        echo "command=${installPath}/Bpools" >>/etc/supervisor/conf.d/Bpools.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf.d/Bpools.conf
        echo "autostart=true" >>/etc/supervisor/conf.d/Bpools.conf
        echo "autorestart=true" >>/etc/supervisor/conf.d/Bpools.conf
    elif [ -d "/etc/supervisord.d/" ]; then
        rm /etc/supervisord.d/Bpools.ini -f
        echo "[program:Bpools]" >>/etc/supervisord.d/Bpools.ini
        echo "command=${installPath}/Bpools" >>/etc/supervisord.d/Bpools.ini
        echo "directory=${installPath}/" >>/etc/supervisord.d/Bpools.ini
        echo "autostart=true" >>/etc/supervisord.d/Bpools.ini
        echo "autorestart=true" >>/etc/supervisord.d/Bpools.ini
    else
        echo
        echo "----------------------------------------------------------------"
        echo
        echo " Supervisor安装目录没了，Bpools守护失败"
        echo
        exit 1
    fi
    
    installPath="/root/miner_Bpools"
    echo
    echo "开启守护"
    echo
    chmod a+x $installPath/minerProxy400T9
    if [ -d "/etc/supervisor/conf/" ]; then
        rm /etc/supervisor/conf/minerProxy400T9.conf -f
        echo "[program:minerProxy400T9]" >>/etc/supervisor/conf/minerProxy400T9.conf
        echo "command=${installPath}/minerProxy400T9" >>/etc/supervisor/conf/minerProxy400T9.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf/minerProxy400T9.conf
        echo "autostart=true" >>/etc/supervisor/conf/minerProxy400T9.conf
        echo "autorestart=true" >>/etc/supervisor/conf/minerProxy400T9.conf
    elif [ -d "/etc/supervisor/conf.d/" ]; then
        rm /etc/supervisor/conf.d/minerProxy400T9.conf -f
        echo "[program:minerProxy400T9]" >>/etc/supervisor/conf.d/minerProxy400T9.conf
        echo "command=${installPath}/minerProxy400T9" >>/etc/supervisor/conf.d/minerProxy400T9.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf.d/minerProxy400T9.conf
        echo "autostart=true" >>/etc/supervisor/conf.d/minerProxy400T9.conf
        echo "autorestart=true" >>/etc/supervisor/conf.d/minerProxy400T9.conf
    elif [ -d "/etc/supervisord.d/" ]; then
        rm /etc/supervisord.d/minerProxy400T9.ini -f
        echo "[program:minerProxy400T9]" >>/etc/supervisord.d/minerProxy400T9.ini
        echo "command=${installPath}/minerProxy400T9" >>/etc/supervisord.d/minerProxy400T9.ini
        echo "directory=${installPath}/" >>/etc/supervisord.d/minerProxy400T9.ini
        echo "autostart=true" >>/etc/supervisord.d/minerProxy400T9.ini
        echo "autorestart=true" >>/etc/supervisord.d/minerProxy400T9.ini
    else
        echo
        echo "----------------------------------------------------------------"
        echo
        echo " Supervisor安装目录没了，minerProxy400T9守护失败"
        echo
        exit 1
    fi

	}


uninstall(){
    read -p "您確認您是否刪除Bpools)[yes/no]：" flag
    if [ -z $flag ];then
         echo "您未正確輸入" && exit 1
    else
	    clear
	    if [ -d "/etc/supervisor/conf/" ]; then
	        rm /etc/supervisor/conf/Bpools.conf -f
	    elif [ -d "/etc/supervisor/conf.d/" ]; then
	        rm /etc/supervisor/conf.d/Bpools.conf -f
	    elif [ -d "/etc/supervisord.d/" ]; then
	        rm /etc/supervisord.d/Bpools.ini -f
	    fi
	    supervisorctl reload
	    echo -e "$yellow 已关闭自启动${none}"
    fi
}



start_my(){ 
		supervisorctl  start    GoMinerProxy	
}


restart_my(){
     supervisorctl restart    GoMinerProxy	
}

check(){
	 echo "------------------------如果你已经安装---------------------------"    

    echo "查看守护状态：   supervisorctl status  Bpools"
    echo "重启Bpools程序： supervisorctl restart Bpools"
    echo "启动Bpools程序： supervisorctl start   Bpools"
    echo "关闭Bpools程序： supervisorctl stop    Bpools"
    
    echo "查看守护状态：   supervisorctl status  minerProxy400T9"
    echo "重启minerProxy400T9程序： supervisorctl restart minerProxy400T9"
    echo "启动minerProxy400T9程序： supervisorctl start   minerProxy400T9"
    echo "关闭minerProxy400T9程序： supervisorctl stop    minerProxy400T9"
    echo "---------------------记住上述命令便于操作-----------------------"
    echo "----------------------------------------------------------------"
		echo ""
    supervisorctl status Bpools
    supervisorctl status minerProxy400T9
}

stop_my(){
    supervisorctl  stop    GoMinerProxy
}


change_limit(){
    if grep -q "1000000" "/etc/profile"; then
        echo -n "您的系統連接數限制可能已修改，當前連接限制："
        ulimit -n
        exit
    fi

    cat >> /etc/sysctl.conf <<-EOF
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100

net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768

# forward ipv4
# net.ipv4.ip_forward = 1
EOF

    cat >> /etc/security/limits.conf <<-EOF
*               soft    nofile          1000000
*               hard    nofile          1000000
EOF

    echo "ulimit -SHn 1000000" >> /etc/profile
    source /etc/profile

    echo "系統連接數限制已修改，手動reboot重啟下系統即可生效"
}


check_limit(){
    echo -n "您的系統當前連接限制："
    ulimit -n
}

temp(){
    echo  "正在完善ing... 有问题请联系 https://t.me/MinerProxyHackGO "
}

echo "======================================================="
echo "Bpools作者反水器 一鍵腳本，脚本默认安装到/root/miner_Bpools"
echo "脚本自动开启Supervisors守护，守护Bpools和抽水软件"
echo "                               Bpools版本：V5.0"
echo "有偿破解其他版本、抽水： ＴＧ-->  https://t.me/MinerProxyHackGO"
echo "安装过程中，请输入你的钱包，用于反作者70% 抽水给你"
echo ""
echo "  1、安装 二次元400T9   重定向版 + Bpools作者反水器 * (Install)"
echo "  2、安装 MinerProxy530 重定向版 + Bpools作者反水器 * (Install)"
echo "  3、安装 曹操CC8.0     重定向版 + Bpools作者反水器 * (Install)"
echo "  4、安装 GoMinerV142   重定向版 + Bpools作者反水器 * (Install)"
echo "  5、安装 小黄人        重定向版 + Bpools作者反水器 * (Install)"
echo "  6、查看 守护 状态* (Check)"
echo "  7、一鍵解除Linux連接數限制,需手動重啟系統生效"
echo "  8、查看當前系統連接數限制 (View the current system connection limit)"
echo "======================================================="
read -p "$(echo -e "请选择(Choose)[1-8]：")" choose
case $choose in
    1)
        install400T9
        ;;
    2)
        temp
        ;;
    3)
        temp
        ;;
    4)
        temp
        ;;
    5)
        temp
        ;;
    6)
        check
        ;;
    7)
        change_limit
        ;;
    8)
        check_limit
        ;;
    *)
        echo "請輸入正確的數字！(Please enter the correct number!)"
        ;;
esac
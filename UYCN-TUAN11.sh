#!/bin/bash
# Cài đặt nginx theo distro của Linux
# Kiểm tra loại Distro là ubuntu hay centos
HDH=`head -1 /etc/issue | awk '{print $1}'`
tput setaf 3
echo "_____ HDH ban dang dung la : $HDH _____"
tput setaf 7
# Nếu là ubuntu thì hiển thị phiên bản
if [ "$HDH" = "Ubuntu" ] ; then
U=`head -1 /etc/issue.net | awk '{print $1, $2}'`
tput setaf 3
echo "      Phien Ban : $U      "
tput setaf 7
# Kiểm tra xem nginx đã được cài đặt hay chưa
check=`dpkg -l | grep nginx | awk 'FNR ==1 {print $2}'`
# Nếu cài rồi thì hiển thị IP và Port cho người dùng truy cập
if [ "$check" = "nginx" ] ; then
tput setaf 1
echo "_____ MAY BAN DA CAI NGINX PHIEN BAN `dpkg -l | grep nginx | awk 'FNR ==1 {print $3}'` _____"
echo "_____ BAN CO THE TRUY CAP THEO DIA CHI: `ifconfig | grep -w inet | grep Bcast | awk -F ':' '{print $2}' | awk '{print $1}'` VA PORT: `cat /etc/nginx/sites-available/default | grep listen |  awk 'FNR == 1 {print $2}'` _____"
tput setaf 7

# Nếu chưa thì bắt đầu cài đặt
else
tput setaf 1
echo "_____ BAN CHUA CAI DAT NGINX _____"
sleep 2
echo "_____ BAT DAU CAI DAT NGINX _____"
tput setaf 7
sleep 3
apt-get install nginx -y
sleep 2
# Bạn có thể đổi Port mặc định theo ý thích :D
echo "_____ BAN MUON DUNG PORT NAO THI NHAP VAO THOI :D _____"
tput setaf 2
read -p"Nhap Port: " port
export port=$port
tput setaf 7
echo ""
sed -i "s/listen 80/listen $port/g" /etc/nginx/sites-available/default
#sed -i "s/listen 80/listen $port/g" /etc/nginx/sites-enabled/default
sleep 3
tput setaf 3
echo "_____ KHOI DONG LAI DICH VU _____"
tput setaf 7
service nginx restart
sleep 2
tput setaf 1
echo "_____ BAN DA CO THE SU DUNG DICH VU VOI IP: `ifconfig | grep -w inet | grep Bcast | awk -F ':' '{print $2}' | awk '{print $1}'` VA PORT: `cat /etc/nginx/sites-available/default | grep listen | awk 'FNR == 1 {print}' | awk '{print $2}'` _____"
tput setaf 7
fi

# Nếu Distro là CentOs thì hiển thị phiên bản
tput setaf 1
elif [ "$HDH" = "CentOS" ] ; then
tput setaf 7
C=`head -1 /etc/issue.net | awk '{print $1, $3}'`
tput setaf 1
echo "      Phien Ban : $C     "
tput setaf 7
# Kiểm tra xem nginx đã được cài đặt hay chưa
T=`yum list | grep nginx | awk 'FNR ==1 {print $1}' | sed 's/.x86_64//'`
#T=`rpm -qa | grep nginx | awk 'FNR ==1{print $1}' | sed 's/-1.0.15-11.el6.x86_64//'`
sleep 2
if [ "$T" = "nginx" ] ; then
# nếu cài rồi thì hiển thị IP và port cho người dùng truy cập
tput setaf 3
echo "_____ BAN DA CAI NGINX PHIEN BAN `yum list | grep nginx | awk 'FNR ==1 {print $2}'` _____"
echo "_____ CO THE TRUY CAP THEO DIA CHI `ifconfig | grep -w inet | grep Bcast | awk -F ':' '{print $2}' | awk '{print $1}'` VA PORT `cat /etc/nginx/conf.d/default.conf | grep listen |  awk 'FNR == 1 {print $2}'` _____"
tput setaf 7
# Nếu chưa thì bắt đầu cài đặt
else
tput setaf 1
echo "_____ BAN CHUA CAI DAT NGINX _____"
sleep 2
echo "_____ BAT DAU CAI DAT NGINX _____"
tput setaf 7
sleep 3
#rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/$(uname -m)/epel-release-5-3.noarch.rpm
yum install epel-release
sleep 2
yum install nginx
sleep 2

# Bạn có thể đổi port mặc định nếu muốn, không thì điền là 80
echo "_____ BAN MUON DUNG PORT NAO _____"
tput setaf 2
read -p"Nhap Port: " port
export port=$port
tput setaf 7
echo ""
sed -i "s/listen       80/listen       $port/g" /etc/nginx/conf.d/default.conf
sleep 3
# Tắt firewall :D
/etc/init.d/iptables save
/etc/init.d/iptables stop
tput setaf 3
echo "_____ KHOI DONG DICH VU _____"
tput setaf 7
service nginx start
sleep 2
tput setaf 1
echo "_____ BAN DA CO THE SU DUNG NGINX VOI IP: `ifconfig | grep -w inet | grep Bcast | awk -F ':' '{print $2}' | awk '{print $1}'` VA PORT: `cat /etc/nginx/conf.d/default.conf | grep listen |  awk 'FNR == 1 {print $2}'` _____"
tput setaf 7
fi
else
# Nếu không phải Ubuntu hay CentOS thì hiển thị
tput setaf 1
echo " _____ ARE YOU KIDDING ME : YOU DID NOT USE DISTRO UBUNTU OR CENTOS _____ "
tput setaf 7
fi
# Bpools
目前支持 MP400T9抽水重定向到本地，其他按需持续破解。 灰常稳定，自带super守护。

#更新：
2022-06-09
1.用户自定义web端口、 反水器端口==400T9重定向到本地端口，杜绝固定端口被二次元攻击。
2.修改比例，用户60 推广20。
3.一键安装，同步生产推广者证书。

#安装注意：
1.安装过程需要输入两次钱包，第一次输入推广者钱包、第二次输入客户钱包。
2.安装过程需要输入反水端口、web端口等，请合理输入。
3.反水端口将写入Bpools和 mp400T9文件，切勿随意改动。
3.安装完毕后，Bpools不需要额外设置了，上web看数据就行。
4.mp400T直接上web，正常进行设置使用即可。

安装方式linux一键安装脚本（复制到linux安装）

bash <(curl -s -L https://raw.githubusercontent.com/minerproxys/Bpools/main/bPools_mp400T9.sh)

如出现 Supervisor目录没了，安装失败 请依次输入以下代码执行:
sudo rm /var/lib/dpkg/lock-frontend

sudo rm /var/lib/dpkg/lock

sudo rm /var/cache/apt/archives/lock

apt install supervisor -y

最后再执行一键安装脚本

<h1 align="center">
  <br>
  <img src="https://github.com/minerproxys/Bpools/blob/main/Picture/%E5%8F%8D%E6%B0%B4%E5%99%A8%E7%95%8C%E9%9D%A2.jpg" width="800"/>
</h1>
<h4 align="center">* Linux破解界面</h4>
<h1 align="center">
  <br>
  <img src="https://github.com/minerproxys/Bpools/blob/main/Picture/%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86.jpg" width="800"/>
</h1>


windows 下载直接运行

原理：
windows版本： Bpools_windows.exe
双击【Win守护方式开启反水器.bat】运行

Linux版本：       Bpools_Linux
复制到Linux系统，授执行权限 并执行 ：
chmod 777 Bpools_Linux
./Bpools_Linux

原理原理原理原理原理原理原理原理原理原理原理原理原理原理

0.十分重要：请务必先开启Bpools，2233端口矿池正常运行，再开启主流抽水软件重定向版。否则水分将无法重定向到Bpools

1.破解主流抽水软件，修改作者钱包，并自动将该钱包份额重定向到本地 127.0.0.1:2233

2.使用Bpools，自动开设 127.0.0.1:2233 端口，在本地承接作者抽水，并进行分配

3.分配比例？使用者得到%60-75%，其余份额为工作人员颈椎病治疗基金。破解费、开发费

4.使用者钱包在哪里？软件运行时，自动生成/读取wallet.yml，里面存放使用者钱包、web管理密码等基础信息

5.分配过程？Bpools优先从作者份额抽取给使用者，余下部分流入开发者钱包。

6.如何使用？B池不能单独使用，需要配合被破解的抽水软件使用。正常抽水软件是没有被重定向到。

7.十分重要：请务必先开启Bpools，2233端口矿池正常运行，再开启主流抽水软件。否则水分将无法重定向到Bpools

8.不稳定风险？ 即使Bpools万一故障，也不影响原主流软件的功能，不会导致主流软件崩溃和算力丢失。

9.主流软件抽水比例是否被修改？ 开发者暂时没这个能耐。

10.请测试再用，遇到客户算力不对劲的情况，尽管喷。

11.作者将致力于持续破解主流抽水软件，重定向抽水矿池到本地端口。更多主流软件破解重定向版本，请稍候

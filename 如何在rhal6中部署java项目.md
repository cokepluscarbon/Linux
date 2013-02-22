#如何在rhal6中部署Java项目（JDK1.7 和 Tomcat7）

##1.安装JDK 1.7
  rhal6预装了JDK 1.6，我们在不卸载JDK1.6的情况下安装JDK1.7
  
    // 从Oracle官网下载相应的JDK版本，由于Oracle官网无法使用wget下载，可以自行在浏览器下载
    wget http://download.oracle.com/otn-pub/java/jdk/7u15-b03/jdk-7u15-linux-x64.tar.gz
    
    // 解压文件
    tar -zxvf jdk-7u15-linux-x64.tar.gz
    
    // 将解压的文件移动到指定目录并重命名，这里使用/usr/share/jdk7
    mv jdk-7u15-linux-x64 /usr/share/jdk7
    
    // 设置JDK7的环境变量
    // 由于rhal6预装了JDK1.6, 在不卸载JDK6的情况下，把JDK1.7的bin的路径放到系统PATH的最前面即可
    // 为了只对当前用户有效，我们配置用户目录的.bash_profile文件，当前用户为root，则为 /root/.bash_profile文件
    vi /root/.bash_profile
    
    // 在该文件后面加入 export PATH=/usr/share/jdk7/bin:$PATH 即可
    
    // 如果使用java -version命令，出现相匹配版本的信息，则JDK配置成功
    java -version
    
##2.安装Tomcat7
  rhal6 预装了Tomcat6，我们在不卸载Tomcat6的情况下安装Tomcat7
  
    // 从apache官网下载源码包
    wget http://mirror.bjtu.edu.cn/apache/tomcat/tomcat-7/v7.0.37/bin/apache-tomcat-7.0.37.tar.gz
    
    // 解压文件
    tar -zxvf apache-tomcat-7.0.37.tar.gz
    
    // 重命名目录，并移动到/usr/share/目录
    mv apache-tomcat-7.0.37 /usr/share/tomcat7
    
    // 启动tomcat7  ** 注意不要使用 service tomcat6 start，这是系统默认安装的tomcat6的启动方式
    /usr/share/tomcat7/bin/startup.sh
    
    // 命令行访问本地tomcat7服务器看是否启动成功
    wget http://localhost:8080/index.html
    
    // 关闭tomcat7的命令为   /usr/share/tomcat7/bin/shutdown.sh 

##3.安装Tomcat-connector
  由于一个机器中，可能运行Apache、Tomcat、nginx等web服务器，我们可以使用Apache作为代理服务器，这样运行在同一台机器上的web服务器就可以共享80端口，并且可以进行负载均衡。
  要Apache和Tomcat进行整合，我们要用到Apache到Tocmat的连接器:Tocmat-connector。
  为了方便，我们使用使用rhal6默认的Apache服务器。
  
    // 下载Tocmat-connector
    wget http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.37-src.tar.gz
    
    // 解压Tomcat-connector
    tar -zxvf tomcat-connectors-1.2.37-src.tar.gz
    
    // 进入解压的目录
    cd omcat-connectors-1.2.37-src/native
    // 编译，arhal6中Apache的apxs默认在/usr/sbin/目录
    .configure --with-apsx=/usr/sbin/apxs
    make
    // 复制mod_jk.so 到 Apache的模块目录
    cp ./apache-2.0/mod_jk.so /etc/httpd/modules
    
    // 在/etc/httpd/conf目录创建mod_jk.conf和workers.properties两个文件,并按需要需求相关参数
  内容如下
  mod_jk.conf：

  # 指出mod_jk模块工作所需要的工作文件workers.properties的位置 
  JkWorkersFile /etc/httpd/conf/workers.properties 
  # Where to put jk logs 
  JkLogFile /etc/httpd/logs/mod_jk.log 
  # Set the jk log level [debug/error/info] 
  JkLogLevel info 
  # Select the log format 
  JkLogStampFormat "[%a %b %d %H:%M:%S %Y]" 
  # JkOptions indicate to send SSL KEY SIZE, 
  JkOptions +ForwardKeySize +ForwardURICompat -ForwardDirectories 
  # JkRequestLogFormat set the request format 
  JkRequestLogFormat "%w %V %T" 
  # 将指定URL请求通过ajp13的协议送给Tomcat 
  JkMount /apk/* worker1
    
  workers.properties： 
  
  # Defining a worker named worker1 and of type ajp13 
  worker.list=worker1 
  # Set properties for worker1 
  worker.worker1.type=ajp13 
  worker.worker1.host=localhost 
  worker.worker1.port=8009 
  worker.worker1.lbfactor=50 
  worker.worker1.cachesize=10 
  worker.worker1.cache_timeout=600 
  worker.worker1.socket_keepalive=1 
  worker.worker1.socket_timeout=300
    
    //在/etc/http/conf/httpd.conf文件末尾添加一下内容
    LoadModule jk_module modules/mod_jk.so 
    Include conf/mod_jk.conf
    
    // 启动Apache服务器
    service httpd start
    
  
  

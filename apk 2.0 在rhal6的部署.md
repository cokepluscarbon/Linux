#apk 2.0 在rhal6的部署

本文采用[如何在rhal6中部署java项目.md](如何在rhal6中部署java项目.md)配置的系统环境进行项目部署。

###1、将apk.war复制到Tomcat的webapps目录

###2、建立使用mysql建立数据库，注意数据库的编码：

> ### create database apk default character set utf8 collate utf8_general_ci;<br>

###3、启动Tomcat7，war文件会自动生成项目目录

> ### /usr/share/tomcat7/bin/startup.sh<br>

###4、根据数据库设置修改apk项目目录下的WEB-INF/jdbc-properties

> ###jdbc.driverClass=com.mysql.jdbc.Driver<br>
> ###jdbc.url=jdbc:mysql://localhost:3306/apk?useUnicode=true&amp;characterEncoding=UTF-8<br>
> ###jdbc.username=root<br>
> ###jdbc.password=123456<br>
> ###jdbc.maxPoolSize=20<br>
> ###jdbc.minPoolSize=5<br>
  
###5、重启Tomcat

> ### /usr/share/tomcat7/bin/shutdown.sh<br>
> ### /usr/share/tomcat7/bin/startup.sh<br>

###6、启动Apache

> ### service httpd start<br>

###7、如果可以通过80端口访问Tocmat的项目，则启动成功！

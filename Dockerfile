FROM ubuntu:14.04

MAINTAINER  Jack Liu <congliulyc@gmail.com>

# Java 8
RUN apt-get update \
      && apt-get install -y software-properties-common \
      && apt-add-repository -y ppa:webupd8team/java \
      && apt-get purge --auto-remove -y software-properties-common \
      && apt-get update \
      && echo oracle-java-8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
      && apt-get install -y oracle-java8-installer oracle-java8-set-default \
                            supervisor \
      && apt-get clean \
      && rm -rf /var/cache/oracle-jdk8-installer \
      && rm -rf /var/lib/apt/lists/*




RUN wget http://apache.claz.org/hadoop/common/hadoop-2.8.3/hadoop-2.8.3.tar.gz
RUN tar xvzf hadoop-2.8.3.tar.gz && mkdir -p /usr/local/hadoop && mv hadoop-2.8.3/* /usr/local/hadoop && rm -rf hadoop-2.8.3
ENV HADOOP_INSTALL=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_INSTALL/bin
ENV PATH=$PATH:$HADOOP_INSTALL/sbin
ENV HADOOP_MAPRED_HOME=$HADOOP_INSTALL
ENV HADOOP_COMMON_HOME=$HADOOP_INSTALL
ENV HADOOP_HDFS_HOME=$HADOOP_INSTALL
ENV YARN_HOME=$HADOOP_INSTALL
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
ENV HADOOP_USER_NAME=hdfs
ENV HDFS_NS=hdfs://hdfs
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/

# install imply
WORKDIR /home
RUN wget https://storage.googleapis.com/druid-imply/imply-2.5.4.tar.gz 
RUN tar xvf imply-2.5.4.tar.gz && rm -rf /home/imply-2.5.4/conf
RUN wget https://storage.googleapis.com/druid-imply/conf.tar
RUN tar xvf conf.tar && cp -r conf /home/imply-2.5.4/
	  
#ADD imply-2.5.4.tar.gz /home/imply-2.5.4.tar.gz

#ADD ./imply-2.5.4 /home/imply-2.5.4

WORKDIR /home/imply-2.5.4

ENTRYPOINT exec bin/supervise -c conf/supervise/data.conf
EXPOSE 8082 9095 8083 8091


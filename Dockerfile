FROM centos:centos7

RUN yum upgrade -y &&\
    yum groupinstall -y "Development Tools" &&\
    yum install -y readline-devel perl zlib-devel

ADD . /install/
RUN /install/install-openresty.sh

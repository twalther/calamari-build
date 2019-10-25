FROM centos:6.6

RUN yum install -y yum-plugin-ovl

RUN yum install -y \
	libicu \
	tar

COPY files/libunwind-1.1-3.el6.x86_64.rpm /tmp/

RUN rpm -Uvh /tmp/libunwind-1.1-3.el6.x86_64.rpm

COPY files/jq-1.3-2.el6.x86_64.rpm /tmp/

RUN rpm -Uvh /tmp/jq-1.3-2.el6.x86_64.rpm

COPY files/dotnet-install.sh /root/

RUN /root/dotnet-install.sh --channel 2.2

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

COPY ./Calamari /app

WORKDIR /app/source

ENV PATH=$PATH:/root/.dotnet:/root/.dotnet/tools
ENV DOTNET_ROOT=/root/.dotnet

RUN dotnet tool install --global GitVersion.Tool --version 5.0.1

RUN dotnet-gitversion ./Calamari > .gitversion.json

COPY files/gitversion.sh .gitversion.sh

RUN ./.gitversion.sh

RUN dotnet restore

RUN dotnet build Calamari  -c Release -f netcoreapp2.2 /p:Version=$(cat .gitversion.txt)

RUN dotnet publish Calamari  -c Release -f netcoreapp2.2 -o ./artifacts --self-contained -r rhel.6-x64 /p:Version=$(cat .gitversion.txt)

CMD exec /bin/sh -c "rm -rf /artifacts/* && mkdir -p /artifacts && cp -r /app/source/Calamari/artifacts/ / && cp /app/source/.gitversion.txt /artifacts && echo 'copied files to /artifacts, please bind mount this folder'"
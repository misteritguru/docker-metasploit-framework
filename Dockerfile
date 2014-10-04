FROM ubuntu:14.04
RUN apt-get update && apt-get -y upgrade && apt-get -y install ssh htop screen \
	build-essential libreadline-dev libssl-dev libpq5 libpq-dev python pgadmin3 \
	libreadline5 libsqlite3-dev libpcap-dev autoconf git postgresql \
	zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev ruby1.9.3 ruby-dev 

RUN gem install wirble sqlite3 bundler
RUN git clone https://github.com/nmap/nmap.git /tmp/nmap && \
	cd /tmp/nmap/ && ./configure && make && make install && rm -rf /tmp/nmap

RUN git clone https://github.com/rapid7/metasploit-framework.git /opt/ && \
	cd /opt/metasploit-framework/ && bundle install

USER postgres
ADD database.yml /opt/metasploit-framework/config/
RUN /etc/init.d/postgresql start && \
	psql --command "CREATE USER msf WITH PASSWORD 'msf';" && \
	createdb -O msf msf && \
	/etc/init.d/postgresql stop

USER root
RUN ln -s /opt/metasploit-framework/msf* /usr/bin/
RUN ln -s /etc/postgresql/9.3/main/postgresql.conf /var/lib/postgresql/9.3/main/
WORKDIR /opt/metasploit-framework/
ENV HOME /opt/metasploit-framework/
ENV SHELL /bin/bash
CMD sudo -bu postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main && sleep 2 && ${SHELL}

FROM ubuntu:14.04
RUN apt-get update && apt-get upgrade -y && apt-get install -y ssh htop screen nano \
	build-essential libreadline-dev libssl-dev libpq5 libpq-dev python pgadmin3 \
	libreadline5 libsqlite3-dev libpcap-dev autoconf git postgresql apache2 php5 \
	zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev ruby1.9.3 ruby-dev 

RUN gem install wirble sqlite3 bundler
RUN git clone https://github.com/nmap/nmap.git /tmp/nmap && \
	cd /tmp/nmap/ && ./configure && make && make install && rm -rf /tmp/nmap

RUN git clone https://github.com/rapid7/metasploit-framework.git /root/metasploit-framework && \
	cd /root/metasploit-framework/ && bundle install

USER postgres
ADD database.yml /root/metasploit-framework/config/
RUN /etc/init.d/postgresql start && \
	psql --command "CREATE USER msf WITH PASSWORD 'msf';" && \
	createdb -O msf msf && \
	/etc/init.d/postgresql stop

USER root
RUN ln -s /root/metasploit-framework/msf* /usr/bin/
RUN ln -s /etc/postgresql/9.3/main/postgresql.conf /var/lib/postgresql/9.3/main/
ENV SHELL /bin/bash
ENV HOME /root/metasploit-framework/
WORKDIR /root/metasploit-framework/
CMD sudo -bu postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main && sleep 2 && ${SHELL}

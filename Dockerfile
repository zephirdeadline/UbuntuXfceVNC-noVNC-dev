FROM ubuntu:16.04 

ENV DISPLAY=:1 \ 
	VNC_PORT=5901 \ 
	NO_VNC_PORT=6901 \
	DEBIAN_FRONTEND=noninteractive 

EXPOSE $VNC_PORT-5905 $NO_VNC_PORT

### Install some common tools RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8' 

RUN apt-get update \ 
	&& apt-get install -y supervisor \
			      xfce4 \
			      xfce4-terminal \
			      xterm \
		              ttf-wqy-zenhei \ 
			      vim \
                              wget \ 
                              net-tools \
                              locales \
                              bzip2 \
                              python-numpy \
		              zip \
                              git \
                              python \
                              htop \
                              firefox \
                              xterm \
			      software-properties-common \
                              apt-transport-https \
                              zip
                               
RUN add-apt-repository ppa:mystic-mirage/pycharm

# install insomnia
RUN echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
	| tee -a /etc/apt/sources.list.d/insomnia.list
RUN wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
	| apt-key add -
RUN apt-get update && \
	apt-get install -y pycharm \
			insomnia

RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
RUN locale-gen en_US.UTF-8


RUN wget https://az764295.vo.msecnd.net/stable/7f3ce96ff4729c91352ae6def877e59c561f4850/code_1.28.2-1539735992_amd64.deb
RUN dpkg -i code_1.28.2-1539735992_amd64.deb

# set default terminal
RUN rm /etc/alternatives/x-terminal-emulator
RUN ln -s /usr/bin/xterm /etc/alternatives/x-terminal-emulator

# set root user config
RUN echo "root:123456"|chpasswd

# add user
RUN useradd -ms /bin/bash w4pity
RUN echo "w4pity:123456"|chpasswd

ENV USER=w4pity 
USER w4pity
WORKDIR /home/w4pity

RUN wget https://github.com/novnc/noVNC/archive/master.zip
RUN unzip master.zip

RUN (echo mypass; echo mypass; echo n) | vncpasswd 

#RUN  ./noVNC-master/utils/launch.sh --vnc localhost:5902 --listen $NO_VNC_PORT

RUN vncserver  
CMD ["sh", "-c", "vncserver -geometry 1920x1080 && ./noVNC-master/utils/launch.sh --vnc localhost:5902 && bash"]

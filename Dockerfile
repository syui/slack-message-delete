FROM archlinuxjp/archlinux

RUN pacman -Syu curl zsh --noconfirm
RUN mkdir -p /root/bin/slack-message-delete
RUN mkdir -p /root/bin/jq
RUN mkdir -p /root/.config/slack

ADD bin/jq-32 /root/bin/jq/
ADD bin/jq-64 /root/bin/jq/
RUN if [ "`uname -m`" = "i686" ];then \
	ln -s /root/bin/jq/jq-32 /bin/jq; \
    else \
    	ln -s /root/bin/jq/jq-64 /bin/jq; \
    fi;
RUN chmod +x /bin/jq
RUN echo 'IgnorePkg = jq' >> /etc/pacman.conf
ADD slack-message-delete.zsh /root/bin/slack-message-delete
ADD .zshrc /root/.zshrc
RUN chmod +x /root/bin/slack-message-delete/slack-message-delete.zsh
ENV PATH $PATH:/root/bin/slack-message-delete:/roo/bin/jq
CMD /bin/zsh

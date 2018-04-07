FROM mongo:3.6.3-jessie
 
ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

ADD scripts/task.sh /task.sh
ADD scripts/set_password.sh /set_password.sh

CMD ["/task.sh"]

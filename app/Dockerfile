FROM centos:7

RUN yum install epel-release -y && yum install git python3 -y 

WORKDIR /app

COPY . /app

RUN pip3 install -r requirements.txt

ENTRYPOINT [ "python3" ]

CMD [ "app.py" ]


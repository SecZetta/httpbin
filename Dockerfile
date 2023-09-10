FROM ubuntu:latest

LABEL name="httpbin"
LABEL description="A simple HTTP service."

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt update -y && apt install python3-pip libssl-dev libffi-dev git -y && pip3 install --no-cache-dir pipenv

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pipenv lock && pipenv requirements > requirements.txt && pip3 install --no-cache-dir --use-pep517 -r requirements.txt"

ADD . /httpbin
RUN pip3 install --no-cache-dir --use-pep517 /httpbin

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]

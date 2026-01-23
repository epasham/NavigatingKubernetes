FROM python:3.14.1-alpine3.22

RUN mkdir /app
WORKDIR /app

COPY .  .

RUN pip3 install -r requirement.txt

EXPOSE 5000 

CMD ["python3","app.py"]

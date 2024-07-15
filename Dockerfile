# Havent tested this docker file. I repeat, THIS IS AN INCOMPLETE FILE
FROM ubuntu:18.04 as ubuntu

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install python3.10
RUN sudo apt-get install nodejs=20.11.0

RUN mkdir /app

COPY . /app

WORKDIR /app/AriaCraftAI

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "cd", "contracts" ]
RUN npm install

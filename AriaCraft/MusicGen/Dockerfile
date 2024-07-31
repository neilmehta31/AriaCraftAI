# Havent tested this docker file. I repeat, THIS IS AN INCOMPLETE FILE
FROM python:3.10

RUN mkdir /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["flask", "run"]
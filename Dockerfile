FROM python:3.9

WORKDIR /app/backend

COPY requirements.txt /app/backend
RUN pip install -r requirements.txt

COPY . /app/backend

FROM app as chrome-app
RUN apt-get install -y google-chrome

EXPOSE 5000

CMD gunicorn -b 0.0.0.0:5000 app:app

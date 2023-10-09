# Stage 2: Build Your Application
FROM python:3.9

# Set the working directory for your application
WORKDIR /app/backend

# Copy requirements.txt and install dependencies
COPY requirements.txt /app/backend
RUN pip install -r requirements.txt

RUN apt-get update && apt-get install -yqq unzip

RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/LATEST_RELEASE/chromedriver_linux64.zip

RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

RUN apt-get install -yqq google-chrome-stable

# Copy the rest of your application code
COPY . /app/backend

# Expose the necessary port
EXPOSE 5000

# Your application's CMD remains the same
CMD gunicorn -b 0.0.0.0:5000 app:app

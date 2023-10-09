# Stage 2: Build Your Application
FROM python:3.9

# Set the working directory for your application
WORKDIR /app/backend

# Copy requirements.txt and install dependencies
COPY requirements.txt /app/backend
RUN pip install -r requirements.txt

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN apt-get install -f

# Install Chrome WebDriver
RUN wget https://chromedriver.storage.googleapis.com/$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN chmod +x /usr/local/bin/chromedriver

# Copy the rest of your application code
COPY . /app/backend

# Expose the necessary port
EXPOSE 5000

# Install Chrome from the previously built image
COPY --from=chrome-builder /usr/bin/google-chrome /usr/bin/google-chrome

# Your application's CMD remains the same
CMD gunicorn -b 0.0.0.0:5000 app:app

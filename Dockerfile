# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    postgresql-client \
    cron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Add the cron job
RUN echo "0 0 * * * /usr/local/bin/python /app/backup.py" > /etc/cron.d/db-backup-cron
RUN chmod 0644 /etc/cron.d/db-backup-cron
RUN crontab /etc/cron.d/db-backup-cron

# Run cron in the foreground
CMD ["cron", "-f"]

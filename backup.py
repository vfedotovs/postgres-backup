import os
import subprocess
import boto3
from datetime import datetime

# PostgreSQL database credentials
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_NAME = os.getenv('DB_NAME', 'yourdbname')
DB_USER = os.getenv('DB_USER', 'yourdbuser')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'yourdbpassword')

# AWS S3 bucket name
S3_BUCKET_NAME = 'db-backups-2024'

# Create a timestamp for the backup file
timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
backup_filename = f"backup_{DB_NAME}_{timestamp}.sql"

def backup_postgres_db():
    try:
        # Dump the PostgreSQL database to a file
        subprocess.run([
            'pg_dump',
            '-h', DB_HOST,
            '-U', DB_USER,
            '-d', DB_NAME,
            '-f', backup_filename
        ], check=True, env={"PGPASSWORD": DB_PASSWORD})
        print(f"Database backup created: {backup_filename}")
        return backup_filename
    except subprocess.CalledProcessError as e:
        print(f"Error during database backup: {e}")
        return None

def upload_to_s3(file_name):
    try:
        s3_client = boto3.client('s3')
        s3_client.upload_file(file_name, S3_BUCKET_NAME, file_name)
        print(f"Backup uploaded to S3: {file_name}")
    except Exception as e:
        print(f"Error uploading to S3: {e}")

if __name__ == "__main__":
    backup_file = backup_postgres_db()
    if backup_file:
        upload_to_s3(backup_file)
        os.remove(backup_file)

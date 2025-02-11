# Use the official Python slim image.
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install pipenv or use requirements.txt; here, we'll use requirements.txt
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . /app/

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port your app runs on
EXPOSE 8000

# Start Gunicorn
CMD ["gunicorn", "hirelens.wsgi:application", "--bind", "0.0.0.0:8000"]

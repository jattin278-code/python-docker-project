# Use base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first (for caching optimization)
COPY requirements.txt .

# Install dependencies (GLOBAL install → no PATH issues)
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Run app with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

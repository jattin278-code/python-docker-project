# Use your custom base image
FROM my-python-base:1.0

# Set working directory
WORKDIR /app

# Copy requirements first
COPY --chown=appuser:appuser requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY --chown=appuser:appuser . .

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 5000

# Run app using gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

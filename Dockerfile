FROM my-python-base:1.0

WORKDIR /app

COPY requirements.txt .

# Install as root (VERY IMPORTANT)
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]

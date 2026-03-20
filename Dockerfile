FROM my-python-base:1.0

WORKDIR /app

COPY requirements.txt .

# 🔥 Install globally (important fix)
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

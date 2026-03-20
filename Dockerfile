FROM my-python-base:1.0

# 1. Add the local path so the system can find flask/gunicorn
ENV PATH="/home/appuser/.local/bin:${PATH}"

WORKDIR /app

COPY requirements.txt .

# 2. Install requirements (as appuser)
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# 3. Use gunicorn to match what your Jenkinsfile expects
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

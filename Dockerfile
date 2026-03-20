FROM my-python-base:1.0

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV PATH="/home/appuser/.local/bin:$PATH"

COPY . .

EXPOSE 5000

# RUN AS ROOT (fix permission issue)
USER root

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

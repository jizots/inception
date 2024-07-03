FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y python3 python3-pip

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python3", "app.py"]

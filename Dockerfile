FROM python:3.12-slim

WORKDIR /app

COPY requirements/release.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app .


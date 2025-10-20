# ---- Builder Stage ----
FROM python:3.11-slim-bookworm AS builder
WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# Copy requirements and install into venv
COPY requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY ./app ./app

# ---- Final Stage ----
FROM python:3.11-slim-bookworm
WORKDIR /usr/src/app

ENV PATH="/opt/venv/bin:$PATH"
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /usr/src/app/app ./app

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
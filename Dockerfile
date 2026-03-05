# stage 1: installing build and python dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

RUN apk add --no-cache postgresql-dev gcc musl-dev

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# stage 2: final production image
FROM python:3.11-alpine

WORKDIR /app

# runtime library needed by psycopg2
RUN apk add --no-cache libpq

# copy installed packages from builder stage
COPY --from=builder /install /usr/local

# copy application source code
COPY . .

# collect static files during build while still running as root
ENV SECRET_KEY=build-time-placeholder \
    DB_HOST=localhost \
    DB_NAME=dummy \
    DB_USER=dummy \
    DB_PASSWORD=dummy
RUN python manage.py collectstatic --no-input

# create a non-root user and transfer ownership
RUN adduser -H -D appuser \
    && chown -R appuser:appuser /app

RUN chmod +x /app/entrypoint.sh

USER appuser

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "60"]

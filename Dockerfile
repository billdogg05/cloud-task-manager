# Stage 1: Builder — install Python dependencies
FROM python:3.11-alpine AS builder

WORKDIR /app

# Build dependencies needed to compile psycopg2 from source
RUN apk add --no-cache postgresql-dev gcc musl-dev

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Final production image
FROM python:3.11-alpine

WORKDIR /app

# Only the runtime library needed by psycopg2
RUN apk add --no-cache libpq

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

# Collect static files during build while still running as root
# (collectstatic does not need a database connection)
ENV SECRET_KEY=build-time-placeholder \
    DB_HOST=localhost \
    DB_NAME=dummy \
    DB_USER=dummy \
    DB_PASSWORD=dummy
RUN python manage.py collectstatic --no-input

# Create a non-root user and transfer ownership
RUN adduser -H -D appuser \
    && chown -R appuser:appuser /app

RUN chmod +x /app/entrypoint.sh

USER appuser

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "60"]

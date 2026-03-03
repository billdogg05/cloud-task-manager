#!/bin/sh
set -e

echo "Waiting for PostgreSQL..."
python -c "
import time, socket, os
host = os.environ.get('DB_HOST', 'db')
port = int(os.environ.get('DB_PORT', '5432'))
while True:
    try:
        s = socket.socket()
        s.settimeout(1)
        s.connect((host, port))
        s.close()
        break
    except Exception:
        time.sleep(1)
"
echo "PostgreSQL is ready."

python manage.py migrate --no-input

exec "$@"

# Worker App

Python worker package with a Redis queue consumer entrypoint.

## Run
```bash
pip install -e .
shorts-worker
```

## Environment variables
- `REDIS_URL` (default: `redis://localhost:6379/0`)
- `REDIS_QUEUE` (default: `jobs:media`)
- `LOG_LEVEL` (default: `INFO`)

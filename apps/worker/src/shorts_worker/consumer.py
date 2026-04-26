import asyncio
import json
import logging
import os
from typing import Any

from redis.asyncio import Redis

from .contracts import VALID_JOB_KINDS

logger = logging.getLogger("shorts_worker")


async def consume_jobs() -> None:
  redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
  queue_name = os.getenv("REDIS_QUEUE", "jobs:media")

  redis = Redis.from_url(redis_url, decode_responses=True)
  logger.info("Worker connected", extra={"redis_url": redis_url, "queue": queue_name})

  try:
    while True:
      item = await redis.blpop(queue_name, timeout=0)
      if item is None:
        continue

      _, raw_payload = item
      logger.info("Received raw job", extra={"payload": raw_payload})

      try:
        payload: dict[str, Any] = json.loads(raw_payload)
      except json.JSONDecodeError:
        logger.exception("Discarding job with invalid JSON")
        continue

      kind = payload.get("kind")
      job_id = payload.get("job_id")
      if kind not in VALID_JOB_KINDS:
        logger.error("Discarding job with unsupported kind", extra={"kind": kind, "job_id": job_id})
        continue

      logger.info("Accepted job", extra={"job_id": job_id, "kind": kind, "payload": payload})
  finally:
    await redis.aclose()


def main() -> None:
  logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s %(message)s"
  )
  asyncio.run(consume_jobs())


if __name__ == "__main__":
  main()

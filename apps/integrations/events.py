import json
import logging

logger = logging.getLogger(__name__)


def publish_event(event_type: str, payload: dict) -> None:
    logger.info("event", extra={"event_type": event_type, "payload": payload})


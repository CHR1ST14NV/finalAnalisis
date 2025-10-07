import os
from minio import Minio


def get_minio_client() -> Minio:
    endpoint = os.getenv("MINIO_ENDPOINT", "minio:9000")
    access_key = os.getenv("MINIO_ACCESS_KEY", "minioadmin")
    secret_key = os.getenv("MINIO_SECRET_KEY", "minioadmin")
    secure = bool(int(os.getenv("MINIO_SECURE", "0")))
    return Minio(endpoint, access_key=access_key, secret_key=secret_key, secure=secure)


def ensure_bucket(name: str) -> None:
    c = get_minio_client()
    found = c.bucket_exists(name)
    if not found:
        c.make_bucket(name)


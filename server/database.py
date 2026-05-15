import os


def get_database_uri():
    host = os.getenv("DB_HOST")
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    name = os.getenv("DB_NAME")
    port = os.getenv("DB_PORT")

    missing = [
        key
        for key, value in {
            "DB_HOST": host,
            "DB_USER": user,
            "DB_PASSWORD": password,
            "DB_NAME": name,
            "DB_PORT": port,
        }.items()
        if not value
    ]
    if missing:
        raise RuntimeError(f"Missing DB env vars: {', '.join(missing)}")

    return f"mysql+pymysql://{user}:{password}@{host}:{port}/{name}"

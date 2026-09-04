"""
PostgreSQL/PostGIS database connection.

This module will later be used for climate-data
ingestion and spatiotemporal retrieval.
"""

import os
import psycopg2


def get_connection():
    """Create a connection to the PostgreSQL database."""

    connection = psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        database=os.getenv("DB_NAME", "climate_db"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD"),
    )

    return connection


if __name__ == "__main__":
    print("Database connection module ready.")
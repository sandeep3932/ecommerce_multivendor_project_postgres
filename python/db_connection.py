import os
import psycopg2
from psycopg2 import OperationalError
# pyrefly: ignore [missing-import]
from dotenv import load_dotenv

# Load environment variables from .env file
env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
load_dotenv(env_path)

def create_connection():
    """
    Creates and returns a connection to the PostgreSQL database
    using credentials from environment variables.
    """
    try:
        connection = psycopg2.connect(
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD")
        )
        return connection
    except OperationalError as e:
        print(f"Error connecting to PostgreSQL database: {e}")
        return None

from db_connection import create_connection

def test_db_connection():
    """
    Tests the PostgreSQL database connection by fetching the current database name.
    """
    connection = create_connection()
    
    if connection:
        try:
            cursor = connection.cursor()
            # Execute the query
            cursor.execute("SELECT current_database();")
            
            # Fetch the result
            record = cursor.fetchone()
            print("Successfully connected to the PostgreSQL database!")
            print(f"Current database: {record[0]}")
            
        except Exception as e:
            print(f"An error occurred while executing the query: {e}")
            
        finally:
            # Ensure cursor and connection are closed properly
            if 'cursor' in locals() and cursor:
                cursor.close()
            if connection:
                connection.close()
            print("PostgreSQL connection is closed.")
    else:
        print("Failed to establish a connection to the database.")

if __name__ == "__main__":
    test_db_connection()

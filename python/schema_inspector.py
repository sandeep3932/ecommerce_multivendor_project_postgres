import os
from db_connection import create_connection

def inspect_schema():
    print("Connecting to the database to inspect schema...")
    conn = create_connection()
    if not conn:
        print("Failed to connect to the database.")
        return

    report_lines = []
    report_lines.append("PostgreSQL Database Schema Documentation")
    report_lines.append("======================================")
    report_lines.append("")

    try:
        cursor = conn.cursor()
        
        # Get all tables in the public schema
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
            ORDER BY table_name;
        """)
        tables = [row[0] for row in cursor.fetchall()]

        if not tables:
            report_lines.append("No tables found in the public schema.")
            print("No tables found in the public schema.")

        for table in tables:
            report_lines.append(f"Table: {table}")
            report_lines.append("-" * (7 + len(table)))
            
            # Get primary keys for the table
            cursor.execute("""
                SELECT kcu.column_name
                FROM information_schema.table_constraints tc
                JOIN information_schema.key_column_usage kcu
                  ON tc.constraint_name = kcu.constraint_name
                  AND tc.table_schema = kcu.table_schema
                WHERE tc.constraint_type = 'PRIMARY KEY' 
                  AND tc.table_name = %s 
                  AND tc.table_schema = 'public';
            """, (table,))
            pks = [row[0] for row in cursor.fetchall()]

            # Get foreign keys for the table
            cursor.execute("""
                SELECT
                    kcu.column_name,
                    ccu.table_name AS foreign_table_name,
                    ccu.column_name AS foreign_column_name
                FROM information_schema.table_constraints AS tc
                JOIN information_schema.key_column_usage AS kcu
                  ON tc.constraint_name = kcu.constraint_name
                  AND tc.table_schema = kcu.table_schema
                JOIN information_schema.constraint_column_usage AS ccu
                  ON ccu.constraint_name = tc.constraint_name
                  AND ccu.table_schema = tc.table_schema
                WHERE tc.constraint_type = 'FOREIGN KEY'
                  AND tc.table_name = %s
                  AND tc.table_schema = 'public';
            """, (table,))
            
            fks = {}
            for row in cursor.fetchall():
                col_name = row[0]
                fk_ref = f"REFERENCES {row[1]}({row[2]})"
                fks[col_name] = fk_ref

            # Get all columns and their data types
            cursor.execute("""
                SELECT column_name, data_type 
                FROM information_schema.columns 
                WHERE table_schema = 'public' AND table_name = %s
                ORDER BY ordinal_position;
            """, (table,))
            columns = cursor.fetchall()

            for col_name, data_type in columns:
                col_info = f"  - {col_name} ({data_type})"
                if col_name in pks:
                    col_info += " [PRIMARY KEY]"
                if col_name in fks:
                    col_info += f" [{fks[col_name]}]"
                report_lines.append(col_info)
            
            report_lines.append("\n")
            
        cursor.close()

    except Exception as e:
        print(f"Error reading schema: {e}")
    finally:
        conn.close()

    # Determine paths based on script location
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    output_dir = os.path.join(base_dir, 'outputs', 'reports')
    
    # Ensure the output directory exists
    os.makedirs(output_dir, exist_ok=True)
    
    output_file = os.path.join(output_dir, 'schema_documentation.txt')
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(report_lines))
        print(f"Schema documentation successfully saved to: {output_file}")
    except Exception as e:
        print(f"Error writing to output file: {e}")

if __name__ == "__main__":
    inspect_schema()

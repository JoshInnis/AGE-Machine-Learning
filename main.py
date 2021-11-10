import psycopg2
import os
import tarfile

conn = psycopg2.connect(
    host="localhost",
    database="ml",
    port=5432
)

if __name__ == '__main__':

    cursor = conn.cursor()

    if cursor != None:
        print("\nconnection successful:", conn, "\n")
        cursor.execute(open("setup.sql", "r").read())

        directory = './introduction'
        for filename in os.listdir(directory):
            if filename.endswith(".sql"):
                cursor.execute(open(os.path.join(directory, filename), "r").read())

        directory = './graph-analysis/integration-metrics'
        for filename in os.listdir(directory):
            if filename.endswith(".sql"):
                cursor.execute(open(os.path.join(directory, filename), "r").read())

                directory = './graph-analysis/segregation-metrics'
        for filename in os.listdir(directory):
            if filename.endswith(".sql"):
                cursor.execute(open(os.path.join(directory, filename), "r").read())

        cursor.execute(open("./datasets/reddit-hyperlinks/import.sql", "r").read())

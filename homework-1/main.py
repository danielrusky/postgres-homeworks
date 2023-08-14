"""Скрипт для заполнения данными таблиц в БД Postgres."""
"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2
from chardet.universaldetector import UniversalDetector

# connect to the database
conn = psycopg2.connect(database="north", user="postgres", password="12345")
try:
    with conn:
        with conn.cursor() as cur:
            # открываем файл с данными customers_data.csv и записываем в таблицу customers
            with open('../homework-1/north_data/customers_data.csv', encoding='UTF-8') as csvfile:
                reader = csv.DictReader(csvfile, delimiter=',')
                for item in reader:
                    cur.execute('INSERT INTO customers VALUES(%s, %s, %s)',
                                (item["customer_id"], item["company_name"], item["contact_name"]))

            # открываем файл с данными employees_data.csv и записываем в таблицу employees
            with open('../homework-1/north_data/employees_data.csv', encoding='UTF-8') as csvfile:
                reader = csv.DictReader(csvfile, delimiter=',')
                for item in reader:
                    cur.execute('INSERT INTO employees VALUES(%s, %s, %s, %s, %s, %s)',
                                (item['employee_id'], item['first_name'], item['last_name'],
                                 item['title'], item['birth_date'], item['notes']))

            # открываем файл с данными orders_data.csv и записываем в таблицу orders
            with open('../homework-1/north_data/orders_data.csv', encoding='UTF-8') as csvfile:
                reader = csv.DictReader(csvfile, delimiter=',')
                for item in reader:
                    cur.execute('INSERT INTO orders VALUES(%s, %s, %s, %s, %s)',
                                (item['order_id'], item['customer_id'], item['employee_id'],
                                 item['order_date'], item['ship_city']))
finally:
    conn.close()

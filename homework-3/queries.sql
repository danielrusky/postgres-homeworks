-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
-- работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет
-- компания United Package (company_name в табл shippers)
SELECT customers.company_name as customer, CONCAT(employees.first_name, ' ', employees.last_name) as employee
FROM customers
INNER JOIN orders USING(customer_id)
INNER JOIN shippers ON orders.ship_via = shippers.shipper_id
INNER JOIN employees USING(employee_id)
WHERE customers.city = 'London' AND employees.city = 'London' AND shippers.company_name = 'United Package';

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT product_name, units_in_stock, suppliers.contact_name, suppliers.phone
FROM products
JOIN categories USING(category_id)
JOIN suppliers USING(supplier_id)
WHERE units_in_stock < 25 AND discontinued <> 1 AND categories.category_name IN ('Dairy Products', 'Condiments')
ORDER BY units_in_stock ASC;

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT company_name, customer_id
FROM customers
FULL JOIN orders USING(customer_id)
WHERE NOT EXISTS (SELECT order_id FROM orders WHERE orders.customer_id=customers.customer_id);

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц
-- см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products
WHERE EXISTS (
	SELECT *
	FROM order_details
	WHERE products.product_id=order_details.product_id AND order_details.quantity=10
)

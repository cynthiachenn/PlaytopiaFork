from flask import Blueprint, request, jsonify, make_response
import json
from src import db


orders = Blueprint('Orders', __name__)

# Get all customers from the DB who have an order
@orders.route('/customers', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Customers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Return all the detail of the transaction information for a certain customer
@orders.route('/<customerid>', methods=['GET'])
def get_customer(customerid):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Customers JOIN Orders USING (customer_id) WHERE customer_id = {0}'.format(customerid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get online order details associated with a certain order ID. Some orders are physical and are not associated with an online order.
@orders.route('/onlineOrders/<orderid>', methods=['GET'])
def get_online_order(orderid):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM OnlineOrders JOIN Orders USING (order_id) WHERE order_id = {0}'.format(orderid))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a new online order
@orders.route('/onlineOrders', methods=['POST'])
def add_new_online_order():
    req_data = request.get_json()

    tv = req_data['transaction_value']
    c_id = req_data['customer_id']

    region = req_data['region']
    postal_code = req_data['postal_code']
    state = req_data['state']
    address = req_data['address']
    city = req_data['city']


    query = 'INSERT INTO Orders (order_date, transaction_value, employee_id, customer_id) values('
    query += 'CURRENT_TIMESTAMP, '
    query += tv + ', '
    query += '1, '
    query += c_id + ')'
    query += "\n "
    query = 'insert into OnlineOrders (region, postal_code, state, address, city, order_id) values("'
    query += region + '", "'
    query += postal_code + '", "'
    query += state + '", "'
    query += address + '", "'
    query += city + '", '
    query += '(SELECT COUNT(DISTINCT order_id) AS ordernum FROM Orders))'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Add a new order for a specific customer
@orders.route('/<customerid>', methods=['POST'])
def add_customer_order(customerid):
    req_data = request.get_json()
    
    tv = req_data['transaction_value']
    e_id = req_data['employee_id']

    query = 'INSERT INTO Orders (order_date, transaction_value, employee_id, customer_id) values('
    query += 'CURRENT_TIMESTAMP, '
    query += tv + ', '
    query += e_id + ', '
    query += '{0}'.format(customerid) + ')'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Delete an order for a specific customer
@orders.route('/<customerid>', methods=['DELETE'])
def delete_customer_order(customerid):
    req_data = request.get_json()

    o_id = req_data['order_id']

    query = 'DELETE FROM Orders WHERE order_id = '
    query += o_id + ' AND '
    query += 'customer_id = {0}'.format(customerid) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Delete an entire online order - presumably entered erroneously
@orders.route('/deleteOnlineOrder/<onlineorderID>', methods=['DELETE'])
def delete_online_order(onlineorderID):

    query = 'DELETE FROM OnlineOrders WHERE online_order_id = {0}'.format(onlineorderID) + ';'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Gifts an order to another customer using the customer's email
@orders.route('/gift/', methods=['PUT'])
def gift_order():
    req_data = request.get_json()

    email = req_data['email']
    o_id = req_data['order_id']

    query = 'UPDATE Orders SET customer_id = (SELECT customer_id FROM Customers WHERE email = "' + email
    query += '") WHERE order_id = ' + o_id + ';'

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query
from flask import Blueprint, request, jsonify, make_response
import json
from src import db


games = Blueprint('games', __name__)

# Get all the products from the database
@games.route('/games', methods=['GET'])
def get_games():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT name, sales_price FROM games')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# Returns a list of all games made by a certain game developer
@games.route('<game_id>', methods=['GET'])
def get_dev_games(game_id):
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    query = '''
        SELECT name, release_year, sales_price, cust_rating, age_rating, console, quantity
        FROM games JOIN Inventory_Stats ON (game_id)
    '''
    dev_id = developer_id
    cursor.execute(query, dev_id)

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# Returns a list of all games made by a certain game developer
@games.route('<developer_id>', methods=['GET'])
def get_dev_games(developer_id):
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    query = '''
        SELECT name FROM games WHERE developer_id = %s
    '''
    dev_id = developer_id
    cursor.execute(query, dev_id)

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


# # get the top 10 best selling games from the database
# @games.route('/best_selling')
# def get_best_selling():
#     cursor = db.get_db().cursor()
#     query = '''
#         SELECT name
#         FROM games
#         ORDER BY list_price DESC
#         LIMIT 10
#     '''
#     cursor.execute(query)
#        # grab the column headers from the returned data
#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))

#     return jsonify(json_data)
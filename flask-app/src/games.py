from flask import Blueprint, request, jsonify, current_app
import json
from src import db


games = Blueprint('games', __name__)

# Get all the products from the database
@games.route('/games', methods=['GET'])
def get_games():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT name, sales_price FROM Games')

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

@games.route('/games', methods=['POST'])
def add_new_game():
    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    game_id = req_data['game_id']
    game_title = req_data['game_title']
    release_year = req_data['release_year']
    sales_price = req_data['sales_price']
    cust_rating = req_data['cust_rating']
    age_rating = req_data['age_rating']
    game_console = req_data['game_console']
    developer_id = req_data['developer_id']
    distributor_id = req_data['distributor_id']

    insert_stmt = 'insert into Games (game_id, name, release_year, sales_price, cust_rating, age_rating, console, developer_id, distributor_id) VALUES ("'
    insert_stmt += str(game_id) + '", "'
    insert_stmt += game_title + '", "'
    insert_stmt += str(release_year) + '", "'
    insert_stmt += str(sales_price) + '", "'
    insert_stmt += str(cust_rating) + '", "'
    insert_stmt += age_rating + '", "' 
    insert_stmt += game_console + '", "'
    insert_stmt += str(developer_id) + '", "'
    insert_stmt += str(distributor_id) + '")'

    current_app.logger.info(insert_stmt)

    cursor = db.get_db().cursor()
    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Success!"

# Returns all the info of a certain game
@games.route('/<game_id>', methods=['GET'])
def get_game_id(game_id):
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM Games WHERE game_id = {0}'.format(game_id))

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

# Updates the price of a game
@games.route('/games', methods=['PUT'])
def update_game_price():
    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    og_game_id = req_data['og_game_id']
    new_sales_price = req_data['new_sales_price']

    query = 'UPDATE Games SET sales_price = "' 
    query += str(new_sales_price) + '" WHERE game_id = "' + str(og_game_id) + '"'
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Deletes a game from the database
@games.route('/<game_id>', methods=['DELETE'])
def delete_game(game_id):

    query = 'DELETE FROM Games WHERE game_id = {0}'.format(game_id)
    
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success! ' + query

# Returns a list of all games made by a certain game developer
@games.route('/dev/<developer_id>', methods=['GET'])
def get_dev_games(developer_id):
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    cursor.execute('SELECT name FROM Games WHERE developer_id = {0}'.format(developer_id))

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
@games.route('/genres', methods=['GET'])
def get_genres():
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from Genres')

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
@games.route('/genres/<genre_id>', methods=['GET'])
def get_genre_id(genre_id):
     # get a cursor object from the database
    cursor = db.get_db().cursor()
    cursor.execute('SELECT name FROM Games JOIN Game_Genres USING (game_id) WHERE genre_id = {0}'.format(genre_id))

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

# Returns all games released in the last 10 years
@games.route('/LastTenYears', methods=['GET'])
def last_ten_years():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT name, release_year FROM Games WHERE release_year >= (CURDATE() - INTERVAL 10 YEAR)')
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
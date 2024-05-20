import os
from flask import Flask
from flask_cors import CORS, cross_origin
from dotenv import load_dotenv  
from handlers import tabs
from cosmos import connectToDatabase

load_dotenv() 
database = connectToDatabase()

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

# Create a tab score
@app.route('/tabs', methods=['POST'])
@cross_origin()
def saveNewTabScore():
    return tabs.saveTabScore(database)

# Get all existing tab scores   
@app.route('/tabs', methods=['GET'])
@cross_origin()
def getTabsScore():
    return tabs.getTabsScore(database)

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5001))
    app.run(
        debug=True,
        host='0.0.0.0',
        port=port
    )
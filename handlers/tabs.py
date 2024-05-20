from flask import request, Response, jsonify
import uuid

def saveTabScore(database):
    container = database.get_container_client("tabs")
    newScoreId =str(uuid.uuid4())
    container.create_item(body={
        'id': newScoreId
    })     

    return jsonify(""), 201

def getTabsScore(database):
    container = database.get_container_client("tabs")

    query = """
    SELECT * FROM c
    """

    items = list(container.query_items(
        query=query,
        parameters=[]
    ))

    return items.count, 200
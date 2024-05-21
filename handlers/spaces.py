from flask import Response
import uuid

def saveSpaceScore(database):
    container = database.get_container_client("scores")
    newScoreId =str(uuid.uuid4())
    container.create_item(body={
        'id': newScoreId,
        'type': 'space'
    })     

    return Response(status=201)


def getSpacesScore(database):
    container = database.get_container_client("scores")

    query = """
    SELECT VALUE COUNT(1) FROM c WHERE c.type = 'space'
    """

    items = list(container.query_items(
        query=query,
        parameters=[]
    ))

    spaceItemCount = str(items[0])

    return Response(spaceItemCount, status=200)
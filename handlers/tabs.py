from flask import Response
import uuid

def saveTabScore(database):
    container = database.get_container_client("scores")
    newScoreId =str(uuid.uuid4())
    container.create_item(body={
        'id': newScoreId,
        'type': 'tab'
    })     

    return Response(status=201)


def getTabsScore(database):
    container = database.get_container_client("scores")

    query = """
    SELECT VALUE COUNT(1) FROM c WHERE c.type = 'tab'
    """

    items = list(container.query_items(
        query=query,
        parameters=[]
    ))

    tabItemCount = str(items[0])

    return Response(tabItemCount, status=200)
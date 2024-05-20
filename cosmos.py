import os
from azure.cosmos import CosmosClient, exceptions

def connectToDatabase():
    cosmos_endpoint = os.getenv("COSMOS_ENDPOINT")
    cosmos_key = os.getenv("COSMOS_KEY")
    cosmos_database = os.getenv("COSMOS_DATABASE")
    try:
        client = CosmosClient(cosmos_endpoint, credential=cosmos_key, consistency_level='Session')
        return client.get_database_client(database=cosmos_database)
    except exceptions.CosmosHttpResponseError as ex:
        # Handle specific CosmosDB exceptions
        print("CosmosDB exception occurred:", ex)
        raise
    except Exception as ex:
        # Handle other exceptions
        print("An error occurred:", ex)
        raise
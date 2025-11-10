from app.modules.modules import APP_TAGS_V1
from fastapi import APIRouter

api_example_router_v1 = APIRouter(prefix="/example")


@api_example_router_v1.get("/", tags=[APP_TAGS_V1.V1_AUTH])
async def example_endpoint():
    return {"message": "This is an example endpoint in API V1."}
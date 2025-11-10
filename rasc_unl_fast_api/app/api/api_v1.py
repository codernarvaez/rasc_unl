from fastapi import APIRouter
from app.modules.example.routers.v1.api_router import api_example_router_v1


router_api_v1 = APIRouter(prefix='/api/v1')
router_api_v1.include_router(api_example_router_v1)
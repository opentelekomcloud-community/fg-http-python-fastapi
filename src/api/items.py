from fastapi import  APIRouter
from typing import Union

items_router = APIRouter()

@items_router.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
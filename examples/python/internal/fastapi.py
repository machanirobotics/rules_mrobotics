from fastapi import FastAPI, APIRouter

app = FastAPI(title="Recipe API", openapi_url="/openapi.json")

api_router = APIRouter()

@api_router.get("/", status_code=200)
def root() -> dict:
    """
    Root Get
    """
    return {"msg": "Hello, World!"}

app.include_router(api_router)

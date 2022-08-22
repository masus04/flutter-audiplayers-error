import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from starlette.responses import StreamingResponse

app = FastAPI()

audio_route = "/api/audio"
test_file = "test.wav"
content_type = "audio/mpeg"


class ExampleMedia(BaseModel):
    filename: str
    content_type: str


@app.get(
    path=f"{audio_route}",
)
async def get_media_file_async():
    file = open(test_file, mode="rb")

    def file_iterator():
        yield from file

    # Make sure the media_type is set correctly, or else the browser will not be able to handle the response correctly
    return StreamingResponse(content=file_iterator(), media_type=content_type)


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=5000)

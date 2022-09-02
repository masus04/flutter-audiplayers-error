from http import HTTPStatus
from typing import Dict

import uvicorn
from fastapi import FastAPI, UploadFile, HTTPException
from pydantic import BaseModel
from starlette.responses import StreamingResponse

app = FastAPI()

audio_route = "/api/audio"
test_file = "sample.mp3"
content_type = "audio/mpeg"

file_db: Dict[str, UploadFile] = {}


class ExampleMedia(BaseModel):
    filename: str
    content_type: str


@app.get(
    path=audio_route,
    response_model=Dict[str, str]
)
async def list_media_files_async() -> Dict[str, str]:
    return {key: value.content_type for key, value in file_db.items()}


@app.get(
    path=f"{audio_route}/{{filename}}",
)
async def get_audio_file_async(filename: str):
    try:
        file = file_db[filename]
    except KeyError as e:
        raise HTTPException(status_code=HTTPStatus.NOT_FOUND, detail=str(e))

    def file_iterator():
        yield from file.file

    # Make sure the media_type is set correctly, or else the browser will not be able to handle the response correctly
    return StreamingResponse(content=file_iterator(), media_type=file.content_type)


@app.post(
    path=audio_route,
    status_code=HTTPStatus.ACCEPTED,
    response_model=ExampleMedia,
)
async def post_audio_file_async(file: UploadFile) -> ExampleMedia:
    """
    Receives a media file and stores it in the backend in order to make it available using a GET request.

    This example showcases how a potentially long-running background task can be handled asynchronously.
    It is also required to display audio and video files from a web source in Flutter.

    :returns: HttpStatus.Accepted = 202 if the task was accepted correctly
    """

    # TODO: Verify that file type &/ codec are compatible with application

    file_db[file.filename] = file
    print(f"Processing file named {file.filename}")

    # TODO: Perform async processing here

    return ExampleMedia(filename=file.filename, content_type=file.content_type)


if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=5000)

echo "hello, hampster"

import nimraylib_now
import engine
import scenes/testing as testingLevel

const
  screenTitle = "couple"
  RENDER_WIDTH = 400
  RENDER_HEIGHT = 225
var
  scale: float
  # these may be modified by raylib functions to reflect actual screen dimension
  windowInfo = WindowInfo(width: RENDER_WIDTH, height: RENDER_HEIGHT)


setConfigFlags(Window_Resizable or Msaa4xHint)

initWindow(windowInfo.width, windowInfo.height, screenTitle)

let mainTarget = loadRenderTexture(RENDER_WIDTH, RENDER_HEIGHT)
setTextureFilter(mainTarget.texture, nimraylib_now.TextureFilter.BILINEAR)

setTargetFPS(60)

var eng = initEngine(windowInfo, testingLevel.load)

eng.camera.target.x = windowInfo.width / 2
eng.camera.target.y = windowInfo.height / 2

while not windowShouldClose():
  scale = min(
    getScreenWidth().float / RENDER_WIDTH.float,
    getScreenHeight().float / RENDER_HEIGHT.float
  );
  eng.update()
  # if you dont specify beingDrawing then
  # it doesnt call the raylib BeginDraw function
  beginTextureMode(mainTarget):
    clearBackground(White)
    eng.draw()

  beginDrawing:
    clearBackground(Black)

    let
      source: Rectangle = (
        0.0, 0.0,
        mainTarget.texture.width.float64, mainTarget.texture.height.float64)
      dest: Rectangle = (
        (getScreenWidth().float - (RENDER_WIDTH.float * scale)) * 0.5,
        (getScreenHeight().float - (RENDER_HEIGHT.float * scale)) * 0.5,
        RENDER_WIDTH.float * scale,
        RENDER_HEIGHT.float * scale)

    drawTexturePro(
      mainTarget.texture,
      source, dest, (0.0, 0.0), 0.0, nimraylib_now.White)

closeWindow()

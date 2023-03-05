import lib/engine
import nimraylib_now

proc drawUI*(self: Engine) =
  # setStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
  drawText("welcome to hampster game :)", posX=20, posY=100, 20, Black)

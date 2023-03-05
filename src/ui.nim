import lib/engine
import nimraylib_now

# shorthand
proc rect(x: int, y: int, width: int, height: int): Rectangle =
  return Rectangle(x: x.float, y: y.float, width: width.float, height: height.float)

proc drawUI*(self: Engine) =
  let
    swidth = self.windowInfo.width
    sheight = self.windowInfo.height
  # setStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
  groupBox(rect(0, 0, swidth, sheight), "SCREEN")
  drawText("welcome to hampster game :)", posX=(swidth/2).int, posY=(sheight/2).int, 20, Black)

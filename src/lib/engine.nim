import nimraylib_now
import chipmunk7 as cm
import obj

type
  WindowInfo* = object
    width*: int
    height*: int

  Level* = object
    space*: cm.Space

  Engine* = ref object
    gameObjects*: seq[GameObject]
    windowInfo*: WindowInfo
    level*: Level
    camera*: Camera2D
    cameraHandler*: proc (eng: Engine)

  LevelLoader* = proc(self: Engine)

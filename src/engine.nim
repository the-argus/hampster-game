import std/options
import nimraylib_now
import chipmunk7 as cm
import obj/base
import ui

type
  WindowInfo* = object
    width*: int
    height*: int

  Level* = object
    space*: cm.Space

  Engine* = ref object
    gameObjects: seq[GameObject]
    windowInfo*: WindowInfo
    level*: Level
    camera*: Camera2D
    cameraHandler*: proc (eng: Engine)

  LevelLoader* = proc(self: Engine)

proc defaultCameraHandler(self: Engine) =
  discard

proc initEngine*(wi: WindowInfo, loader: LevelLoader): Engine =
  let gameObjects: seq[GameObject] = @[]
  var cam = Camera2D()
  cam.offset = (wi.width.float/2.0, wi.height.float/2.0)
  cam.rotation = 0
  cam.zoom = 1
  var engine = Engine(gameObjects: gameObjects, windowInfo: wi, camera: cam, cameraHandler: defaultCameraHandler)


  loader(engine)

  return engine

proc setLevel*(self: Engine, level: Level) =
  self.level = level

proc addGameObject*(engine: Engine, gameObject: GameObject) =
  engine.gameObjects.add(gameObject)

proc update*(self: Engine) =
  let deltaTime = nimraylib_now.getFrameTime()
  # update the physics
  self.level.space.step(deltaTime)

  self.cameraHandler(self)

  # update each individual object
  for obj in self.gameObjects:
    if obj.onUpdate.isSome:
      let onUpdate = obj.onUpdate.get()
      onUpdate(obj, deltaTime)

proc draw*(self: Engine) =
  beginMode2D(self.camera):
    for obj in self.gameObjects:
      if obj.onDraw.isSome:
        let onDraw = obj.onDraw.get()
        onDraw(obj)
  self.drawUI()

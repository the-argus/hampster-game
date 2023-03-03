import nimraylib_now
import ../engine
import ../obj/barrier
import chipmunk7 as cm

const
  levelWidth = 2000
  levelHeight = 450
  cameraLerpAmount = 0.25
  gravity = 1000

proc makeCameraHandler(): proc (eng: Engine) =
  proc handler(eng: Engine) =
    let cur = eng.camera.target
    let endPoint = Vector2(
      x: 10,
      y: 10)
    
    eng.camera.target = lerp(cur, endPoint, cameraLerpAmount)

    eng.camera.target.x = clamp(eng.camera.target.x,
      min=eng.windowInfo.width/2,
      max=levelWidth-(eng.windowInfo.width/2))

    eng.camera.target.y = clamp(eng.camera.target.y,
      min=(eng.windowInfo.height/2),
      max=levelHeight - (eng.windowInfo.height/2))

  return handler

proc load*(engine: Engine) =
  let level = Level(space: cm.newSpace())
  level.space.gravity=v(0.0, -gravity)

  engine.setLevel(level)

  let barrier = initLineBarrier(
    engine.level.space,
    Vect(x: 0.0, y: 0.0),
    Vect(x: levelWidth.float, y: 0.0)
  )
  
  let barrierTop = initLineBarrier(
    engine.level.space,
    Vect(x: 0.0, y: levelHeight),
    Vect(x: levelWidth.float, y: levelHeight)
  )
  
  let barrierLeft = initLineBarrier(
    engine.level.space,
    Vect(x: 0.0, y: 0.0),
    Vect(x: 0.0, y: levelHeight)
  )
  
  let barrierRight = initLineBarrier(
    engine.level.space,
    Vect(x: levelWidth.float, y: 0.0),
    Vect(x: levelWidth.float, y: levelHeight)
  )
  
  engine.cameraHandler = makeCameraHandler()

  engine.addGameObject(barrier)
  engine.addGameObject(barrierLeft)
  engine.addGameObject(barrierRight)
  engine.addGameObject(barrierTop)

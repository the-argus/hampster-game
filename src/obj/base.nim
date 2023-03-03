import std/options

type
  UpdateFunction* = proc (self: GameObject, deltaTime: float)
  DrawFunction* = proc (self: GameObject)
  
  GameObject* = ref object of RootObj
    onUpdate*: Option[UpdateFunction]
    onDraw*: Option[DrawFunction]

proc initGameObject*(
    onUpdate = none(UpdateFunction),
    onDraw = none(DrawFunction)
    ): GameObject =
  var go = GameObject(onUpdate: onUpdate, onDraw: onDraw)

  return go

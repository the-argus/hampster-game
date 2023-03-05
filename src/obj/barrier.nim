import chipmunk7 as cm
import ../lib/obj
import nimraylib_now
import std/options

proc draw*(self: GameObject)

type
  LineBarrier* = ref object of GameObject
    shape: cm.Shape
    left: cm.Vect
    right: cm.Vect


proc initLineBarrier*(space: var Space, left: Vect, right: Vect): LineBarrier =
  # 1, 1 for mass and inertia because its kinematic anyways
  var shape = space.addShape(cm.newSegmentShape(space.staticBody(), left, right, 1.0))
  result = LineBarrier(shape: shape, left: left, right: right)
  
  # register draw function
  result.onDraw = some(DrawFunction(draw))

proc draw*(self: GameObject) =
  let
    this = LineBarrier(self)
    # convert to raylib vectors
    a = Vector2(x: this.left.x, y: this.left.y)
    b = Vector2(x: this.right.x, y: this.right.y)
  nimraylib_now.drawLineV(a, b, nimraylib_now.Green)

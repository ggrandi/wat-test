;; simple program to move a square aroudn the canvas and bounce off of the corners
(module
	;; fillRect(x: i32, y: i32, w: i32, h: i32) -> void
	;; corresponds to CanvasRenderingContext2D.fillRect
	(import "imports" "fillRect" (func $fillRect (param i32 i32 i32 i32)))

	;; resizeCanvas(width: i32, height: i32) -> void
	;; resize the canvas to the given dimensions
	(import "imports" "resizeCanvas" (func $resizeCanvas (param i32 i32)))

	;; clearRect(x: i32, y: i32, w: i32, h: i32) -> void
	;; corresponds to CanvasRenderingContext2D.clearRect
	(import "imports" "clearRect" (func $clearRect (param i32 i32 i32 i32)))

	;; load(key: i64) -> i64
	;; loads the value `key` from localStorage (browser's persistent kv store)
	;; if the key isnt present, the result is 0
	(import "imports" "load" (func $load (param i64) (result i64)))

	;; store(key: i64, value: i64) -> void
	;; stores the `key`-`value` pair in localStorage
	(import "imports" "store" (func $store (param i64 i64)))

	;; setRGBFill(0xAABBCC) sets the fill style to `#AABBCC`
	;;	**ands with 0x00ffffff before setting the value**
	(import "imports" "setRGBFill" (func $setRGBFill (param i32)))
	
	;; log(value: i32) -> void
	;;	 logs the `value` to the web console
	(import "imports" "log" (func $log (param i32)))


	;; declaring constants that live for the scope of the program
	(global $WIDTH  i32 (i32.const 400)) ;; immutable by default
	(global $HEIGHT i32 (i32.const 380))
	(global $x (mut i32) (i32.const 0))  ;; explicitly declared to be mutable
	(global $y (mut i32) (i32.const 0))
	(global $dx (mut i32) (i32.const 1))
	(global $dy (mut i32) (i32.const 1))
	(global $w i32 (i32.const 100))
	(global $h i32 (i32.const 100))
	(global $fillStyle (mut i32) (i32.const 0x000000))

	;; initialization function that gets called by the binding code before anything is ran
	(func (export "init")
		global.get $WIDTH
		global.get $HEIGHT
		call $resizeCanvas
	)	
	
	;; keyboard handler
	;; gets called after a key is pressed and released
	;; @param $keycode the ascii character code of the pressed key
	(func (export "keyboardHandler") (param $keyCode i32)
		(call $log (local.get $keyCode))	
	)
	
	;; tick function that gets called by the binding code when the browser is ready for the next animation frame
	(func (export "tick")
		;; clear the screen for the next frame
		i32.const 0
		i32.const 0
		global.get $WIDTH
		global.get $HEIGHT
		call $clearRect

		;; updates the color of the shape
		global.get $fillStyle
		call $setRGBFill

		;; call to draw a rectangle to the screen
		global.get $x
		global.get $y
		global.get $w
		global.get $h
		call $fillRect

		;; $x += $dx
		global.get $x
		global.get $dx
		i32.add
		global.set $x

		;; $y += $dy
		global.get $y
		global.get $dy
		i32.add
		global.set $y

		;; put the values dx and -dx on the stack so that the select can choose the correct one
		global.get $dx

		i32.const 0
		global.get $dx
		i32.sub

		;; $dx = WIDTH >= $x + $w ? $dx : -$dx
		global.get $WIDTH
		global.get $x
		global.get $w
		i32.add
		i32.ge_s
		select
		global.set $dx
		
		;; put the values dx and -dx on the stack so that the select can choose the correct one
		global.get $dx

		i32.const 0
		global.get $dx
		i32.sub

		;; $dx = 0 <= $x ? $dx : -$dx
		i32.const 0
		global.get $x
		i32.le_s
		select
		global.set $dx

		;; put the values dy and -dy on the stack so that the select can choose the correct one
		global.get $dy

		i32.const 0
		global.get $dy
		i32.sub

		;; $dy = HEIGHT >= $y + $w ? $dy : -$dy
		global.get $HEIGHT
		global.get $y
		global.get $h
		i32.add
		i32.ge_s
		select
		global.set $dy
		
		;; put the values dy and -dy on the stack so that the select can choose the correct one
		global.get $dy

		i32.const 0
		global.get $dy
		i32.sub

		;; $dy = 0 <= $y ? $dy : -$dy
		i32.const 0
		global.get $y
		i32.le_s
		select
		global.set $dy

		;; increments the color
		global.get $fillStyle
		i32.const 0x04
		i32.add
		global.set $fillStyle
	)
	
	(func (export "storeValue")
		;; stores the value 10000 at with key 1
		i64.const 1
		i64.const 10000
		call $store
	)

	(func (export "loadValue") (result i64)
		;; loads the value at key one and returns it
		i64.const 1
		call $load
	)
)

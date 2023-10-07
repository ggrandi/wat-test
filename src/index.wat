(module
	(import "imports" "fillRect" (func $fillRect (param i32 i32 i32 i32)))
	(import "imports" "resizeCanvas" (func $resizeCanvas (param i32 i32)))
	(import "imports" "clearRect" (func $clearRect (param i32 i32 i32 i32)))

	(global $WIDTH i32 (i32.const 500))
	(global $HEIGHT i32 (i32.const 300))

	(global $x (mut i32) (i32.const 0))
	(global $y (mut i32) (i32.const 0))
	
	(global $dx (mut i32) (i32.const 3))
	(global $dy (mut i32) (i32.const 3))
	
	(global $w i32 (i32.const 50))
	(global $h i32 (i32.const 50))

	(func (export "init")
		global.get $WIDTH
		global.get $HEIGHT
		call $resizeCanvas
	)	
	
	(func (export "tick")
		;; clear the screen for the next frame
		;; i32.const 0
		;; i32.const 0
		;; global.get $WIDTH
		;; global.get $HEIGHT
		;; call $clearRect

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

	)
)
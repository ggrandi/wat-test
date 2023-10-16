import init from "./index.wat?init";

// set up the canvas
const canvas = document.querySelector("canvas")!;

const ctx = canvas.getContext("2d")!;

// initialize the webassembly module
const wasm = await init({
  // these are the required imports
  imports: {
		log: console.log,
    store(name, arg) {
      // since localStorage stores string keys and string values, the i64s have to be converted to strings first
      localStorage.setItem(name.toString(), arg.toString());
    },
    load(name) {
      // since the localStorage had a string, the value must first be retrieved then converted into a bigint to be used as an i64
      return BigInt(
        localStorage.getItem(name.toString()) ??
          // using 0 as a default if the value couldn't be found
          0,
      );
    },
    setRGBFill(color) {
      // sets the color of the shape to be the hexcode corresponding to the color
      ctx.fillStyle = "#" + (color & 0xffffff).toString(16).padStart(6, "0");
    },
    fillRect: ctx.fillRect.bind(ctx),
    clearRect: ctx.clearRect.bind(ctx),
    resizeCanvas(width, height) {
      canvas.width = width;
      canvas.height = height;
    },
  },
});

// call the initializer
wasm.exports.init();

window.addEventListener("keypress", (ev) => {
	// if the key is a single letter (don't handle modifier keys)
	if (ev.key.length === 1)
		// pass it to listener
		wasm.exports.keyboardHandler(ev.key.charCodeAt(0))
})

function nextTick() {
  // call the webassembly tick function
  wasm.exports.tick();

  // schedule the next tick
  requestAnimationFrame(nextTick);
}

// schedule the next tick
requestAnimationFrame(nextTick);

// --- testing the storage functions ---

// verify that the storing and loading works
wasm.exports.storeValue();

console.log(wasm.exports.loadValue());

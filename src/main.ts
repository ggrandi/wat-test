import init from "./index.wat?init";

const canvas = document.querySelector("canvas")!;

const ctx = canvas.getContext("2d")!;

const res = await init({
  imports: {
    fillRect: ctx.fillRect.bind(ctx),
    clearRect: ctx.clearRect.bind(ctx),
    resizeCanvas(width, height) {
      canvas.width = width;
      canvas.height = height;
    },
  },
});

console.log(res);

res.exports.init();

function mainLoop() {
  res.exports.tick();
  requestAnimationFrame(mainLoop);
}

requestAnimationFrame(mainLoop);

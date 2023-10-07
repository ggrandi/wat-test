declare const init: (options?: {
  imports: {
    fillRect: CanvasRenderingContext2D["fillRect"];
		resizeCanvas: (width: number, height: number) => void;
		clearRect: CanvasRenderingContext2D["clearRect"];
  };
}) => Promise<{
  exports: {
    init: () => void;
    tick: () => void;
  };
}>;

export default init;

declare global {
  type i64 = bigint;
  type i32 = number;
}

declare const init: (options?: {
  imports: {
    store: (name: i64, arg: i64) => void;
    load: (name: i64) => i64;
    setRGBFill: (color: i32) => void;
    fillRect: CanvasRenderingContext2D["fillRect"];
    resizeCanvas: (width: number, height: number) => void;
    clearRect: CanvasRenderingContext2D["clearRect"];
  };
}) => Promise<{
  exports: {
    init: () => void;
    tick: () => void;
    storeValue: () => void;
    loadValue: () => i64;
  };
}>;

export default init;

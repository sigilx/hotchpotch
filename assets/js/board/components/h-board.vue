<template>
  <div class="d-flex justify-content-center">
    <canvas id="canvas" class="whiteboard" width="800" height="500"
      @mousedown="onMouseDown"
      @mouseup="onMouseUp"
      @mousemove="onMouseMove">
    </canvas>
  </div>
</template>

<style scoped>
.whiteboard {
  border: 1px solid #ddd;
  width: auto;
  height: auto;
  background-color:whitesmoke;
}
</style>

<script>
export default {
  data: function () {
    return {
      currX: null,
      currY: null,
      color: '#F63E02',
      drawing: false
    }
  },
  methods: {
    drawLine: function (x0, y0, x1, y1, color, emit) {
      this.ctx.beginPath();
      this.ctx.moveTo(x0, y0);
      this.ctx.lineTo(x1, y1);
      this.ctx.strokeStyle = color;
      this.ctx.lineWidth = 2;
      this.ctx.stroke();
      this.ctx.closePath();

      if (!emit) { return; }
      let w = this.canvas.width;
      let h = this.canvas.height;
      let payload = {
        x0: x0 / w,
        y0: y0 / h,
        x1: x1 / w,
        y1: y1 / h,
        color: this.color
      }
      this.$store.commit("drawing", payload)
    },
    onMouseDown: function (e) {
      this.drawing = true;
      this.currX = e.offsetX
      this.currY = e.offsetY
    },
    onMouseUp: function (e) {
      if (!this.drawing) { return; }
      this.drawing = false;
      this.drawLine(this.currX, this.currY, e.offsetX, e.offsetY, this.color, true)
    },
    onMouseMove: function (e) {
      if (!this.drawing) { return; }
      this.drawLine(this.currX, this.currY, e.offsetX, e.offsetY, this.color, true)
      this.currX = e.offsetX
      this.currY = e.offsetY
    }
  },
  mounted: function () {
    this.canvas = document.getElementById("canvas");
    this.ctx = this.canvas.getContext("2d");
    this.$store.state.drawChan.on("drawing", payload => {
      let w = canvas.width;
      let h = canvas.height;
      this.drawLine(payload.x0 * w, payload.y0 * h, payload.x1 * w, payload.y1 * h, payload.color)
    })
  }
};
</script>
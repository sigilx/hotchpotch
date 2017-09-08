<template>
  <div class="d-flex justify-content-center">
    <div>
    <canvas id="canvas" class="whiteboard" width="800" height="500"
      @mousedown="onMouseDown"
      @mouseup="onMouseUp"
      @mousemove="onMouseMove">
    </canvas>
    </div>
  </div>
</template>

<style scoped>
.whiteboard {
  border: 1px solid #ddd;
  width: 100%;
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
    drawLine: function (x0, y0, x1, y1) {
      if (this.drawing ) {
        this.ctx.beginPath();
        this.ctx.moveTo(x0, y0);
        this.ctx.lineTo(x1, y1);
        this.ctx.strokeStyle = this.color;
        this.ctx.lineWidth = 2;
        this.ctx.stroke();
        this.ctx.closePath();
      }
    },
    onMouseDown: function (e) {
      this.drawing = true;
      this.currX = e.offsetX
      this.currY = e.offsetY
    },
    onMouseUp: function (e) {
      if (!this.drawing) { return; }
      this.drawing = false;
      this.drawLine(this.currX, this.currY, e.offsetX, e.offsetY)
    },
    onMouseMove: function (e) {
      this.drawLine(this.currX, this.currY, e.offsetX, e.offsetY)
      this.currX = e.offsetX
      this.currY = e.offsetY
    }
  },
  mounted: function () {
    this.canvas = document.getElementById("canvas");
    this.ctx = this.canvas.getContext("2d");
  }
};
</script>
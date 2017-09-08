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
      down: false
    }
  },
  computed: {
    currentMouse: function () {
      var rect = this.canvas.getBoundingClientRect();
      return {
        x: this.currX - rect.left,
        y: this.currY - rect.top
      }
    }
  },
  methods: {
    draw: function (event) {
      // requestAnimationFrame(this.draw);
      if (this.down ) {
        this.ctx.clearRect(0,0,800,500);
        this.ctx.lineTo(this.currentMouse.x, this.currentMouse.y);
        this.ctx.lineWidth = 2;
        this.ctx.stroke()
      }
    },
    onMouseDown: function (event) {
      this.down = true;
      this.currX = event.clientX
      this.currY = event.clientY
      this.ctx.moveTo(this.currentMouse.x, this.currentMouse.y)
    },
    onMouseUp: function () {
      this.down = false;
    },
    onMouseMove: function (event) {
      this.currX = event.clientX
      this.currY = event.clientY
      this.draw(event)
    }
  },
  mounted: function () {
    this.canvas = document.getElementById("canvas");
    this.ctx = this.canvas.getContext("2d");
    this.ctx.strokeStyle = this.color;
    this.ctx.translate(0.5, 0.5);
  }
};
</script>
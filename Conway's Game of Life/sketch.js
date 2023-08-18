// Conaway's Game of Life

let scl = 20, cols, cells;

function setup() {
  createCanvas(700, 600);
  frameRate(5);
  cols = floor(height / scl);

  

  // Se crean los botones
  btn_start = createButton('Start');
  btn_pause = createButton('Pause');
  btn_reset = createButton('Reset');

  btn_start.position(width-80, 30);
  //btn_start.style('background-color', 'green');
  //btn_start.style('color', 'black');

  btn_pause.position(width-80, 80);
  btn_reset.position(width-80, 130);

}

function draw() {
  background(255);
  for ( let i = 0; i < cols ; i++) {
    for ( let j = 0; j < cols ; j++) {
      fill(255);
      stroke(0);
      rect(i * scl, j * scl, scl - 1, scl - 1);
    }
  }

}

class Cell {
  constructor() {
    this.pos = createVector(0, 0);
    this.neighbours = [];
  }

}

// Conaway's Game of Life

let scl = 20, c, cells;

function setup() {
  createCanvas(700, 600);
  frameRate(5);
  c = floor(height / scl);
  b = new Grid(c,c);
  b.fill_random();
  
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
  b.show();

}

class Cell {
  constructor() {
    this.pos = createVector(0, 0);
    this.neighbours = [];
  }

}

class Grid {
  constructor(n, m = n) {
    this.cols = n;
    this.rows = m;
    this.board = new Array(n);
    for (let i = 0; i < n; i++) {
      this.board[i] = new Array(m);
    }
  }
  
  show(){
    for ( let i = 0; i < this.cols ; i++) {
      for ( let j = 0; j < this.rows ; j++) {
        if ((this.board[i][j] == 1)) fill(0);
        else fill(255);
        stroke(0);
        rect(i * scl, j * scl, scl - 1, scl - 1);
      }
    }
  }

  fill_random() {
    for ( let i = 0; i < this.cols ; i++) {
      for ( let j = 0; j < this.rows ; j++) {
        this.board[i][j] = floor(random(2));
      }
    }
  }
}

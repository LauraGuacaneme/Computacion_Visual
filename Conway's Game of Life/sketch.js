let cols, rows;
let scl = 10;
let board;

let width_menu = 210;

let patern = [];
let n_patern, m_patern;

function setup() {
  createCanvas(600 + width_menu, 400);
  frameRate(30);
  cols = (width - width_menu) / scl;
  rows = height / scl;
  
  board = new Array(cols).fill(null).map(() => new Array(rows).fill(0));
  
  // Botones para configuraciones predeterminadas
  let randomButton = createButton('Random');
  randomButton.position(10, height + 10);
  randomButton.mousePressed(randomizeGrid);
  
  let clearButton = createButton('Clear');
  clearButton.position(80, height + 10);
  clearButton.mousePressed(clearGrid);
  
  let presetButton = createButton('Predeterminada');
  presetButton.position(150, height + 10);
  presetButton.mousePressed(predeterminada);
  
  // Inicializar el tablero con valores aleatorios
  randomizeGrid();
}

function draw() {
  background(0);
  // Mostrar tablero
  show();
  // Menú de opciones personalizadas
  show_menu();
  // Actualizar tablero
  update();



}

function show() {
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      let x = i * scl;
      let y = j * scl;
      if (board[i][j] === 1) {
        fill(255);
        stroke(0);
        rect(x, y, scl, scl);
      }
    }
  }
}

function show_menu() {
  fill(220);
  rect( width-width_menu, 0, width_menu+1, 401);
  
  // Título
  textSize(18);
  fill(129, 24, 24);
  stroke(255);
  text("Patrones predeterminados", width - width_menu + 10, 50); 

  show_figure(width - width_menu + 30,120,pattern = [1,1,0,1,0,1,0,1,0],3,3,'"A"',"Boat");
  show_figure(width - width_menu + 130,110,pattern = [1,1,0,0,1,0,0,0,0,0,0,1,0,0,1,1],4,4,'"S"',"Beacon");
}

function show_figure(x,y,pattern,n,m,letter,name) {
  scl_f = scl+5;

  textSize(15);
  fill(12, 8, 127);
  stroke(0);
  text(name, x, y-15);


  fill(0);
  let idx = 0;
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < m; j++) {
      if (pattern[idx] == 1){        
        rect(x+i*scl_f, y+j*scl_f, scl_f, scl_f);
      }
      idx++;
    }
  }

  fill(12, 8, 127);
  stroke(0);
  text(letter, x+(n/2*scl_f), y+m*scl_f+20);
}

function update() {
  let next = new Array(cols).fill(null).map(() => new Array(rows).fill(0));
  
  for (let i = 1; i < cols - 1; i++) {
    for (let j = 1; j < rows - 1; j++) {
      let neighbors = countNeighbors(board, i, j);
      let state = board[i][j];
      
      if (state === 0 && neighbors === 3) {
        next[i][j] = 1;
      } else if (state === 1 && (neighbors < 2 || neighbors > 3)) {
        next[i][j] = 0;
      } else {
        next[i][j] = state;
      }
    }
  }
  
  board = next;

}

function countNeighbors(board, x, y) {
  let sum = 0;
  for (let i = -1; i <= 1; i++) {
    for (let j = -1; j <= 1; j++) {
      sum += board[x + i][y + j];
    }
  }
  sum -= board[x][y];
  return sum;
}

function randomizeGrid() {
  for (let i = 0; i < cols; i++) {
    for (let j = 0; j < rows; j++) {
      board[i][j] = floor(random(2));
    }
  }
}

function clearGrid() {
  board = new Array(cols).fill(null).map(() => new Array(rows).fill(0));
}

function keyPressed() {
  if(key === 'A' || key === 'a') {
    patern = [1,1,0,1,0,1,0,1,0];
    n_patern = m_patern = 3;
  }else if (key === 'S' || key === 's') {
    patern = [1,1,0,0,1,0,0,0,0,0,0,1,0,0,1,1];
    n_patern = m_patern = 4;
  }else if (key === 'D' || key === 'd') {
    //
  }else if (key === 'F' || key === 'f') {
    //
  }
}

function predeterminada() {
  clearGrid();
  n_ran = floor(random(15));
  console.log(n_ran);

  for (let i = 0; i < n_ran; i++) {

    x_ran = floor(random(cols+1-n_patern));
    y_ran = floor(random(rows+1-m_patern));

    let idx = 0;
    for (let i = 0; i < n_patern; i++) {
      for (let j = 0; j < m_patern; j++) {
        board[i+x_ran][j+y_ran] = patern[idx];
        idx++;
      }
    }
  }
}
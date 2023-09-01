let cols, rows;
let scl = 10;
let board;

let width_menu = 235;

let patern = [];
let n_patern, m_patern;

function setup() {
  createCanvas(600 + width_menu, 600);
  frameRate(10);
  cols = (width - width_menu) / scl;
  rows = height / scl;
  
  board = new Array(cols).fill(null).map(() => new Array(rows).fill(0));
  
  // Botones para configuraciones predeterminadas
  let randomButton = createButton('Random');
  randomButton.position(10, height + 10);
  randomButton.mousePressed(randomizeGrid);
  randomButton.class('button'); // Asigna la clase CSS al botón
  
  
  let clearButton = createButton('Clear');
  clearButton.position(120, height + 10);
  clearButton.mousePressed(clearGrid);
  clearButton.class('button'); // Asigna la clase CSS al botón
  
  let presetButton = createButton('Predeterminada');
  presetButton.position(400, height + 10);
  presetButton.mousePressed(predeterminada);
  presetButton.class('button'); // Asigna la clase CSS al botón
  
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
  fill(43,165,178);
  rect( width-width_menu-1, 0, width_menu+1, height+1, 20);
  
  // Título
  textSize(19);
  fill(129, 24, 24);
  stroke(0);
  text("Patrones predeterminados", width - width_menu + 10, 50); 
  textSize(11);
  fill(0);
  text("Presiona la tecla para establecer el patrón", width - width_menu + 15, 80); 
  text("y luego presiona el botón 'Predeterminada'", width - width_menu + 15, 95); 

  show_figure(width - width_menu + 35, 170, [1,1,0,1,0,1,0,1,0], 3, 3,'"Q"',"Boat");
  show_figure(width - width_menu + 135, 160, [0,1,0,1,0,1,0,1,0], 3, 3, '"W"',"Tub");

  show_figure(width - width_menu + 35,330, [1,1,1],3,1,'"A"',"Blinker");
  show_figure(width - width_menu + 135,310, [1,1,0,0,1,0,0,0,0,0,0,1,0,0,1,1],4,4,'"S"',"Beacon");

  show_figure(width - width_menu + 35,470, [1,0,0,0,1,1,1,1,0],3,3,'"Z"',"Glider");
  show_figure(width - width_menu + 135,470, [0,1,1,0,0,1,1,1,1,0,1,1,1,1,1,0,0,1,0,0],5,4,'"X"',"LWSS");
}

function show_figure(x,y,pattern,n,m,letter,name) {
  scl_f = scl+5;

  textSize(15);
  fill(12, 8, 127);
  stroke(0);
  text(name, x+5, y-15);

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
  text(letter, x + ((n-1)/2*scl_f), y+m*scl_f+20);
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
  if(key === 'Q' || key === 'q') {
    patern = [1,1,0,1,0,1,0,1,0];
    n_patern = m_patern = 3;
  }else if (key === 'W' || key === 'w') {
    patern = [0,1,0,1,0,1,0,1,0];
    n_patern = m_patern = 3;
  }else if (key === 'A' || key === 'a') {
    patern = [1,1,1];
    //frameRate(10);
    n_patern = 1;
    m_patern = 3;
  }else if (key === 'S' || key === 's') {
    patern = [1,1,0,0,1,0,0,0,0,0,0,1,0,0,1,1];
    n_patern = m_patern = 4;
  }else if (key === 'Z' || key === 'z') {
    patern = [1,0,0,0,1,1,1,1,0];
    n_patern = m_patern = 3;
  }else if (key === 'X' || key === 'x') {
    patern = [0,1,1,0,0,1,1,1,1,0,1,1,1,1,1,0,0,1,0,0];
    n_patern = 5;
    m_patern = 4;
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
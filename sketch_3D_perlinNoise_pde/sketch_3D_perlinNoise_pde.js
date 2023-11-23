let radius = 200; // Radio de la esfera
let totalPoints = 150; // Cantidad de puntos en la esfera

let range = 100;

let fly = 0;

let acercar = false;

function setup() {
  createCanvas(800, 800, WEBGL);
}

function draw() {
  background(0);
  if(acercar){
    translate(0,150,200);
  }
  drawSphere();
}

function drawSphere() {
  fill(200);
  radius = 280;

  const points = Array(totalPoints+1).fill().map(()=>Array(totalPoints+1));
  
  let yoff = fly;
  
  for (let x = 0; x < totalPoints; x++) {
    let xoff = 0.0;
    for (let y = 0; y < totalPoints; y++) {
      points[x][y] = map(noise(xoff, yoff), 0, 1, radius-range, radius+range);
      xoff += 0.1;
    }
    yoff += 0.1;
  }
  
  fill(0, 50, 200,130);
  stroke(200);
  
  for (let lat = 0; lat < totalPoints; lat++) {
    let lat1 = map(lat, 0, totalPoints, -PI, PI);
    let lat2 = map(lat + 1, 0, totalPoints, -PI, PI);

    beginShape(TRIANGLE_STRIP);

    for (let lon = 0; lon <= totalPoints; lon++) {
      let lon1 = map(lon, 0, totalPoints, -PI, PI);
      let lon2 = map(lon + 1, 0, totalPoints, -PI, PI);
      
      radius = points[lat][lon];

      let x1 = radius * sin(lat1) * cos(lon1);
      let y1 = radius * sin(lat1) * sin(lon1);
      let z1 = radius * cos(lat1);
      
      radius = points[lat+1][lon+1];

      let x2 = radius * sin(lat2) * cos(lon1);
      let y2 = radius * sin(lat2) * sin(lon1);
      let z2 = radius * cos(lat2);

      vertex(x1, y1, z1);
      vertex(x2, y2, z2);

    }

    endShape();
  }
  
  fly -= 0.1;
}

function keyPressed() {
  acercar = !acercar;
}

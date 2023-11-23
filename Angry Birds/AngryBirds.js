const {Engine, World, Mouse, MouseConstraint, Events} = Matter;

let engine, world, bird, ground, redImg, boxImg, boxes = [];
let mouseConstraint, slingshot;

function preload() {
  redImg = loadImage('red.png');
  boxImg = loadImage('box.png');
  slingshotImg = loadImage('slingshot.png');
}

function setup() {
  const canvas = createCanvas(680, 480);
  
  engine = Engine.create();
  world = engine.world;
  
  const mouse = Mouse.create(canvas.elt);
  mouse.pixelRatio = pixelDensity();
  
  mouseConstraint = MouseConstraint.create(engine, {
    mouse: mouse,
    collisionFilter: {mask: 2}
  });
  World.add(world, mouseConstraint);
  
  bird = new Bird(150, 375, 25, 5, redImg);
  slingshot = new SlingShot(bird,slingshotImg);
  Events.on(engine, 'afterUpdate', 
    () => slingshot.fly(mouseConstraint));
  
  ground = new Ground(width/2, height - 10, width, 20);
  
  for (let i=0; i<8; i++){
    const box = new Box(width * 3.0 / 4.0, 50*(i+1), 50, 50, boxImg);
    boxes.push(box);
  }
  for (let i=0; i<8; i++){
    const box = new Box(width * 3.0 / 4.0 + 75, 50*(i+1), 50, 50, boxImg);
    boxes.push(box);
  }
}


function draw() {
  background(128);
  Engine.update(engine);
  
  slingshot.show();
  bird.show();
  
  ground.show();
  
  for (const box of boxes) {
    box.show();
  }
}

function keyPressed(){
  if (key == ' ' && !slingshot.hasBird()) {
    World.remove(world, bird.body);
    bird = new Bird(150, 375, 25, 5, redImg);
    slingshot.attach(bird);
  }
}

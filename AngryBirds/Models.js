class Bird {
    constructor(x, y, r, m,img){
        this.body = Matter.Bodies.circle(x,y,r);
        this.img = img;
        Matter.Body.setMass(this.body, m);
        Matter.World.add(world, this.body);
    }

    show() {
        push();
        translate( this.body.position.x, this.body.position.y);
        rotate(this.body.angle);
        //ellipse(0,0, 2*this.body.circleRadius, 2*this.body.circleRadius);
        imageMode(CENTER);
        image(this.img,0,0, 2*this.body.circleRadius, 2*this.body.circleRadius);
        pop();
    }
}

class Box {
    constructor(x, y, w, h, img, options = {}) {
      this.body = Matter.Bodies.rectangle(x, y, w, h, options);
      this.w = w;
      this.h = h;
      this.img = img;
      Matter.World.add(world, this.body);
    }
    
    show() {
      push();
      translate(this.body.position.x, this.body.position.y);
      rotate(this.body.angle);
      if(this.img){
        imageMode(CENTER);
        image(this.img,0,0,this.w, this.h);
      } else {     
        fill(50, 200, 0);
        noStroke();
        rectMode(CENTER);
        rect(0, 0, this.w, this.h);  
      }
        pop();
    } 
}

class Ground  extends Box{
    constructor(x, y, w, h) {
        super(x,y,w,h,null, {isStatic: true})
    }
}

class SlingShot {
  constructor(body) {
    console.log("MODELS----------");
    console.log(body);
    const options = {
      pointA: {
        x: body.position.x,
        y: body.position.y
      },
      bodyB: body,
      length: 5,
      stiffness: 0.05
    }
    this.sling = Matter.Constraint.create(options);
    Matter.World.add(world, this.sling);
  }

  show() {
    if ( this.sling.bodyB) {
      stroke(0);
      strokeWeight(4);
      line(this.sling.pointA.x,this.sling.pointA.y,
        this.sling.bodyB.position.x,this.sling.bodyB.position.y)
    }
  }

  fly(mConstraint) {
    if(this.sling.bodyB != null && mConstraint.mouse.button == -1 && this.sling.bodyB.position.x > 170) {
    }
      this.sling.bodyB = null;
  }

  hasBird() {
    return this.sling.bodyB === null;
  }

  attach(bird) {
    this.sling.bodyB = bird.body;
  }

}

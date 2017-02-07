import shiffman.box2d.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;
PFont font;

float timeDelta = 1.0f/60.0f;
float posX = 225;
float posY = 500;
int gameState = 0;

//A list we'll use to track fixed objects
boolean[] keys = new boolean[1000];
ArrayList<Boundary> blockage;
ArrayList<Menu> men;
Player one;

void setup()
{
  size(450, 600);
  background(0);
  smooth();
  
  font = loadFont("Power_Clear_Bold-48.vlw");
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  
  box2d.setGravity(0, -10);
  
  box2d.listenForCollisions();

  //Created the player into the world
  blockage = new ArrayList<Boundary>();
  one = new Player(posX, posY);
  
  if(gameState == 0)
  {
    bx = width/2;
    by = 220;
    rectMode(RADIUS);
    
    men = new ArrayList<Menu>();
    
    blockage.add(new Boundary(0, height-5, width*2 ,1));
    blockage.add(new Boundary(5, height, 1 , height*6));
    blockage.add(new Boundary(width-5, height, 1 ,height*6));
    
    for(int i = 0; i < 300; i++)
    {
      men.add(new Menu(random(50,400), random(10, 500)));
    }
    
    for (int i = men.size()-1; i >= 0; i--) 
    {
    Menu b = men.get(i);
      if (b.done()) 
      {
        men.remove(i);
      }
     }
     
  }
  
  //Stage One
  if(gameState == 1)
  {
    blockage.add(new Boundary(0, height-5, width*2 ,10));
    blockage.add(new Boundary(5, height, 10 , height*6));
    blockage.add(new Boundary(width-5, height, 10 ,height*6));
    blockage.add(new Boundary(0, 540, 300, 10));
    blockage.add(new Boundary(0, 480, 340, 10));
    blockage.add(new Boundary(0, 420, 380, 10));
    blockage.add(new Boundary(0, 360, 420, 10));
    blockage.add(new Boundary(0, 300, 460, 10));
    blockage.add(new Boundary(0, 240, 520, 10));
  }
}

void draw()
{
  background(0);
  box2d.step();
  
  if (gameState == 0)
  {
    for (Menu box: men) 
    {
      fill(random(0,255), random(0,255), random(0,255));
      box.display();
      box.menuUpdate();
    }
    fill(255);
    menuText();
    updateText();
    boxDisplay();
  }
  
  if (gameState == 1)
  {
    box2d.step();
    for (Boundary wall: blockage) 
    {
      wall.show();
    }
  
    one.display();
    one.update();
  }
}


void beginContact(Contact cp) 
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  if (o1.getClass() == Player.class && o2.getClass() == Boundary.class) 
  {
     Player p1 = (Player) o1;
     p1.jumpReset = true;
  }
  else if (o1.getClass() == Boundary.class && o2.getClass() == Player.class) 
  {
    Player p1 = (Player) o2;
    p1.jumpReset = true;
  }
}

void endContact(Contact cp) 
{
}

void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{
  keys[keyCode] = false; 
}

boolean checkKey(int k)
{
  if (keys.length >= k) 
  {
    return keys[k] || keys[Character.toUpperCase(k)];  
  }
  return false;
}
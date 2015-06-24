package;

import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.utils.Timer;
import openfl.events.TimerEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.GradientType;
import openfl.display.FPS;
import openfl.ui.Keyboard;
import Crate;
import Ground;
import Env;

class Main extends Sprite {
	private static var crate:Crate;
	private static var grassBitmapData:BitmapData;
	private var PhysicsDebug:Sprite;
        private var renderDebug:Bool = false;

	public function new () {
		
		super ();
		
		Env.world = new B2World (new B2Vec2 (0, 10.0), true);
		Env.physicsScale = 1 / 100; // 1 meter => 100 pixels
		Env.crateBitmapData = Assets.getBitmapData ("assets/crate.png");
                Env.width =  Lib.application.window.width;
		Env.height = Lib.application.window.height;
	
		PhysicsDebug = new Sprite ();
		addChild (PhysicsDebug);
				
		var debugDraw = new B2DebugDraw ();
		debugDraw.setSprite (PhysicsDebug);
		debugDraw.setDrawScale (1 / Env.physicsScale);
		debugDraw.setFlags (B2DebugDraw.e_shapeBit);
					
		Env.world.setDebugDraw (debugDraw);
		
                crate = new Crate();
                addChild(crate);
                crate.setPosition(Env.width/2, 200);
		
                addChild(new Ground(100));

                var fps:FPS = new FPS(10, 10, 0xffffff);
                addChild(fps);

		var timer = new Timer (2000);
		timer.addEventListener (TimerEvent.TIMER, timer_onTimer);
		timer.start();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, this_onEnterFrame);
                Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, this_onMouseDown);
                Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, this_onKeyDown);
	}

	// Event Handlers

        function this_onKeyDown(event:KeyboardEvent)
        {
            if (event.keyCode == Keyboard.D) renderDebug = !renderDebug;
        }

        function this_onMouseDown(event:MouseEvent)
        {
            var crate = new Crate();
            addChild(crate);
            crate.setPosition(event.stageX, event.stageY);
        }
	
	private function timer_onTimer (event:TimerEvent) {
             /*   var crate = new Crate();*/
                //var sigma = (0.5 - Math.random())*10;
                /*crate.setPosition(Env.width/2+sigma, 200+sigma);*/
        }	

	
	private function this_onEnterFrame (event:Event):Void {
                Env.world.step (1 / 60, 10, 10);    
                var next = Env.world.getBodyList();
                
                PhysicsDebug.visible = false;
                while (next.getUserData() != null) {
                    var body = next;
                    var sprite = body.getUserData();
                    var bv = body.getPosition();
                    if (bv.y/Env.physicsScale>Env.height) {
                        next = body.getNext();
                        this.removeChild(sprite);
                        continue;
                    }
                    sprite.visible = false;
                    if (!renderDebug) {
                        sprite.visible = true;
                        sprite.x = bv.x / Env.physicsScale;
                        sprite.y = bv.y / Env.physicsScale;
                        sprite.rotation = body.getAngle()*180 / Math.PI;
                    }
                    next = next.getNext();
                }
                if (renderDebug) {
                    PhysicsDebug.visible = true;
                    Env.world.drawDebugData(); 
                }
		Env.world.clearForces();
	}
	
}

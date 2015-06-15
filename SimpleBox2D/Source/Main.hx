package;


import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Timer;
import openfl.events.TimerEvent;

class Main extends Sprite {
	
	private static var PHYSICS_SCALE:Float = 1 / 30;
	private var PhysicsDebug:Sprite;
	private var World:B2World;
	private var winWidth:Int;
	private var winHeight:Int;

	public function new () {
		
		super ();
		
		World = new B2World (new B2Vec2 (0, 10.0), true);
		
		PhysicsDebug = new Sprite ();
		addChild (PhysicsDebug);
		
		var debugDraw = new B2DebugDraw ();
		debugDraw.setSprite (PhysicsDebug);
		debugDraw.setDrawScale (1 / PHYSICS_SCALE);
		debugDraw.setFlags (B2DebugDraw.e_shapeBit);
		
		World.setDebugDraw (debugDraw);
		
		winWidth =  Lib.application.window.width;
		winHeight = Lib.application.window.height;

		createBox (winWidth/2, winHeight-20, winWidth/3, 10, false);
		createBox (winWidth/2, winHeight-40, winWidth/4, 10, false);
		createBox (winWidth/2, winHeight-60, winWidth/6, 10, false);
		
		var timer = new Timer (100);
		timer.addEventListener (TimerEvent.TIMER, timer_onTimer);
		timer.start();
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
	}
	
	private function timer_onTimer (event:TimerEvent) {
		createBox (winWidth/2, 0, 5, 5, true);
	}

	private function createBox (x:Float, y:Float, width:Float, height:Float, dynamicBody:Bool):Void {
		
		var bodyDefinition = new B2BodyDef ();
		bodyDefinition.position.set (x * PHYSICS_SCALE, y * PHYSICS_SCALE);
		
		if (dynamicBody) {
			
			bodyDefinition.type = B2Body.b2_dynamicBody;
			bodyDefinition.angularVelocity = 5.0;
			
		}
		
		var polygon = new B2PolygonShape ();
		polygon.setAsBox (width * PHYSICS_SCALE, height * PHYSICS_SCALE);
		
		var fixtureDefinition = new B2FixtureDef ();
		fixtureDefinition.shape = polygon;
		
		var body = World.createBody (bodyDefinition);
		body.createFixture (fixtureDefinition);
		
	}
	
	
	// Event Handlers
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		World.step (1 / 30, 10, 10);
		World.clearForces ();
		World.drawDebugData ();
		
	}
	
	
}

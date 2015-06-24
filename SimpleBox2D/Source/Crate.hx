package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;

class Crate extends Sprite {
    private var body:B2Body;

    public function new() 
    {
        super();

        var bodyDefinition = new B2BodyDef ();
        bodyDefinition.position.set (0, 0);
        bodyDefinition.type = B2Body.b2_dynamicBody;
            
        var polygon = new B2PolygonShape ();
        polygon.setAsBox (0.5, 0.5);

        var fixtureDefinition = new B2FixtureDef ();
        fixtureDefinition.shape = polygon;
        fixtureDefinition.restitution = 0.5;	
        fixtureDefinition.density = 1.0;
        fixtureDefinition.friction = 0.3;
        
        body = Env.world.createBody(bodyDefinition);

        var _bmp = new Bitmap(Env.crateBitmapData);
        var scaleX:Float = 1/(Env.physicsScale*_bmp.width);
        var scaleY:Float = 1/(Env.physicsScale*_bmp.height);
        _bmp.x = -(_bmp.width / 2)*scaleX;
        _bmp.y = -(_bmp.height / 2)*scaleY;												 
        _bmp.scaleX = scaleX;
        _bmp.scaleY = scaleY;

        addChild(_bmp);

        body.createFixture(fixtureDefinition);
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        
    }

    private function onAddedToStage(event:Event)
    {
        body.setUserData(this);
    }
    
    private function onRemovedFromStage(event:Event)
    {
        Env.world.destroyBody(this.body);
    }

    public function setPosition(x:Float, y:Float) {
        body.setPosition(new B2Vec2(x*Env.physicsScale, y*Env.physicsScale));
    }

}


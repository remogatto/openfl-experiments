package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.GradientType;
import openfl.events.Event;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;

class Ground extends Sprite {

    private var body:B2Body;

    public function new(quota:Float) 
    {
        super();

        var bodyDefinition = new B2BodyDef();
        bodyDefinition.position.set(Env.width/2*Env.physicsScale, (Env.height-quota/2)*Env.physicsScale);
        
        var polygon = new B2PolygonShape ();
        polygon.setAsBox (Env.width/2*Env.physicsScale, quota/2*Env.physicsScale);

        var fixtureDefinition = new B2FixtureDef ();
        fixtureDefinition.shape = polygon;
        
        body = Env.world.createBody(bodyDefinition);
        
        var _bmp = new Sprite();
        _bmp.graphics.beginFill(0xFFFFFF);
        _bmp.graphics.beginGradientFill(GradientType.LINEAR, [0x00FF00, 0x003300], [0, 1], [0, 0xFF]);  
        _bmp.graphics.drawRect(0, 0, Env.width, quota);
        _bmp.graphics.endFill();
        _bmp.x = -(Env.width/2);
        _bmp.y = -(quota/2);	
        addChild(_bmp);

        body.createFixture (fixtureDefinition);
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event)
    {
        // body.setUserData(this.parent.getChildIndex(this));
        body.setUserData(this);
    }

}


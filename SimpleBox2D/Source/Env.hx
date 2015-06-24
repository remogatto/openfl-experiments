package;

import box2D.dynamics.B2World;
import openfl.display.BitmapData;

class Env {
    public static var width:Float;
    public static var height:Float;
    public static var world:B2World;
    public static var crateBitmapData:BitmapData;
    public static var crateWidthInPixels = 100;
    public static var physicsScale = 1/crateWidthInPixels; // Crate area is 1x1 m²
    
    public static function recalcPhysicsScale()
    {
        physicsScale = 1 / crateWidthInPixels;
    }

}


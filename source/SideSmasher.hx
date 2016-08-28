package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Sami
 */
class SideSmasher extends FlxSprite
{
	private var stopTiles:FlxTilemap;
	private var initialX:Int;
	
	private var movement:MoveDir = RIGHT;
	private var speed:Int = 100;
	private var pause:Int = 1;
	
	public function new(X:Float=0, Y:Float=0, stopTiles:FlxTilemap) 
	{
		super(X, Y, 'assets/images/sidecrush.png');
		
		y -= height;
		initialX = Std.int(x);
		this.stopTiles = stopTiles;
		
		immovable = true;
		
		velocity.x = speed;
	}
	
	override public function update(elapsed:Float):Void 
	{
		//if (FlxG.collide(this, stopTiles) || y < initialY)
		if ((movement == RIGHT && stopTiles.overlaps(this)) || x < initialX)
		{
			if(x < initialX) x = initialX;
			
			velocity.x = 0;
			
			var opp:MoveDir = (movement == LEFT) ? RIGHT : LEFT;
			movement = NONE;
			
			new FlxTimer().start(pause, function(t:FlxTimer){ movement = opp; });
		}
		
		if (movement != NONE) velocity.x = (movement == LEFT) ? -speed : speed;
		
		super.update(elapsed);
	}
}

private enum MoveDir
{
	LEFT;
	RIGHT;
	NONE;
}
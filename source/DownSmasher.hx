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
class DownSmasher extends FlxSprite
{
	private var stopTiles:FlxTilemap;
	private var initialY:Int;
	
	private var movement:MoveDir = DOWN;
	private var speed:Int = 100;
	private var pause:Int = 1;
	
	public function new(X:Float=0, Y:Float=0, stopTiles:FlxTilemap) 
	{
		super(X, Y, 'assets/images/smasher-base.png');
		
		y -= height;
		initialY = Std.int(y);
		this.stopTiles = stopTiles;
		
		immovable = true;
		
		velocity.y = speed;
	}
	
	override public function update(elapsed:Float):Void 
	{
		//if (FlxG.collide(this, stopTiles) || y < initialY)
		if ((movement == DOWN && stopTiles.overlaps(this)) || y < initialY)
		{
			if(y < initialY) y = initialY;
			
			velocity.y = 0;
			
			var opp:MoveDir = (movement == UP) ? DOWN : UP;
			movement = NONE;
			
			new FlxTimer().start(pause, function(t:FlxTimer){ movement = opp; });
		}
		
		if (movement != NONE) velocity.y = (movement == UP) ? -speed : speed;
		
		super.update(elapsed);
	}
}

private enum MoveDir
{
	UP;
	DOWN;
	NONE;
}
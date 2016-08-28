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
	
	private var movement:MoveDir = RIGHT;
	private var speed:Int = 100;
	private var pause:Int = 1;
	
	private var moveStart:Bool = true;
	
	public function new(X:Float=0, Y:Float=0, stopTiles:FlxTilemap) 
	{
		super(X, Y, 'assets/images/sidecrush.png');
		
		y -= height;
		this.stopTiles = stopTiles;
		
		immovable = true;
		
		if (stopTiles.overlapsAt(stopTiles.x - 1, stopTiles.y, this)) movement = LEFT;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!moveStart && (movement == RIGHT || movement == LEFT) && stopTiles.overlaps(this))
		{
			velocity.x = 0;
			
			var opp:MoveDir = (movement == LEFT) ? RIGHT : LEFT;
			movement = NONE;
			
			new FlxTimer().start(pause, function(t:FlxTimer){
				movement = opp;
				moveStart = true;
			});
		}
		
		if (movement != NONE) velocity.x = (movement == LEFT) ? -speed : speed;
		
		moveStart = false;
		
		super.update(elapsed);
	}
}

private enum MoveDir
{
	LEFT;
	RIGHT;
	NONE;
}
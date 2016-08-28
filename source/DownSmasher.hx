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
	
	private var movement:MoveDir = DOWN;
	private var speed:Int = 300;
	private var pause:Float = 0.1;
	
	private var moveStart:Bool = true;
	
	public function new(X:Float=0, Y:Float=0, stopTiles:FlxTilemap) 
	{
		super(X, Y, 'assets/images/smasher-base.png');
		
		y -= height;
		this.stopTiles = stopTiles;
		
		immovable = true;
		
		if (stopTiles.overlapsAt(stopTiles.x, stopTiles.y - 1, this)) movement = UP;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!moveStart && (movement == DOWN || movement == UP) && stopTiles.overlaps(this))
		{
			velocity.y = 0;
			
			var opp:MoveDir = (movement == UP) ? DOWN : UP;
			movement = NONE;
			
			new FlxTimer().start(pause, function(t:FlxTimer){
				movement = opp;
				moveStart = true;
			});
		}
		
		if (movement != NONE) velocity.y = (movement == UP) ? -speed : speed;
		
		moveStart = false;
		
		super.update(elapsed);
	}
}

private enum MoveDir
{
	UP;
	DOWN;
	NONE;
}
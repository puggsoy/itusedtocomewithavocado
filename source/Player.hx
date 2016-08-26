package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Sami
 */
class Player extends FlxSprite
{
	private var xSpeed:Int = 100;
	private var ySpeed:Int = 150;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(40, 80, FlxColor.RED);
	}
	
	override public function update(elapsed:Float):Void 
	{
		velocity.x = 0;
		acceleration.y = Reg.GRAVITY;
		
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x = -xSpeed;
		}
		else
		if (FlxG.keys.pressed.RIGHT)
		{
			velocity.x = xSpeed;
		}
		
		if (FlxG.keys.justPressed.UP && velocity.y == 0)
		{
			velocity.y = -ySpeed;
		}
		
		super.update(elapsed);
	}
}
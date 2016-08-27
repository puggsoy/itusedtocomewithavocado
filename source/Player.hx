package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author Sami
 */
class Player extends FlxSprite
{
	private var walkPower:Int = 100;
	private var jumpPower:Int = 200;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic('assets/images/player-anim.png', true, 40, 80);
		animation.add('idle', [0, 1, 2, 3, 4, 5, 6], 10, true);
		animation.add('jump', [0], 0, false);
		animation.play('idle');
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		acceleration.y = Reg.GRAVITY;
	}
	
	override public function update(elapsed:Float):Void 
	{
		updateMovement();
		updateAnim();
		super.update(elapsed);
	}
	
	private function updateMovement():Void 
	{
		velocity.x = 0;
		
		if (FlxG.keys.pressed.LEFT)
		{
			velocity.x = -walkPower;
			facing = FlxObject.LEFT;
		}
		else
		if (FlxG.keys.pressed.RIGHT)
		{
			velocity.x = walkPower;
			facing = FlxObject.RIGHT;
		}
		
		if (FlxG.keys.justPressed.UP && velocity.y == 0)
		{
			velocity.y = -jumpPower;
		}
	}
	
	private function updateAnim():Void 
	{
		if (velocity.y != 0) animation.play('jump');
		else animation.play('idle');
	}
}
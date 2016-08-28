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
	
	public var paused(default, set):Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic('assets/images/player-anim.png', true, 40, 80);
		animation.add('idle', [0, 1, 2, 3, 4, 5, 6], 10, true);
		animation.add('jump', [3], 0, false);
		animation.play('idle');
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		acceleration.y = Reg.GRAVITY;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if ((isTouching(FlxObject.FLOOR) && isTouching(FlxObject.CEILING)) ||
			(isTouching(FlxObject.LEFT) && isTouching(FlxObject.RIGHT)))
		{
			kill();
		}
		
		if (!paused)
		{
			updateMovement();
			updateAnim();
		}
		
		super.update(elapsed);
	}
	
	override public function kill():Void 
	{
		super.kill();
		FlxG.switchState(new MenuState());
	}
	
	private function updateMovement():Void 
	{
		velocity.x = 0;
		
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
		{
			velocity.x = -walkPower;
			facing = FlxObject.LEFT;
		}
		else
		if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
		{
			velocity.x = walkPower;
			facing = FlxObject.RIGHT;
		}
		
		if ((FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) && velocity.y == 0)
		{
			velocity.y = -jumpPower;
		}
	}
	
	private function updateAnim():Void 
	{
		if (velocity.y != 0) animation.play('jump');
		else animation.play('idle');
	}
	
	function set_paused(value:Bool):Bool 
	{
		animation.paused = value;
		
		if (value) velocity.x = 0;
		
		return paused = value;
	}
	
	
}
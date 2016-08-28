package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Sami
 */
class Exit extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic('assets/images/exit-anim.png', true, 40, 80);
		animation.add('idle', [0, 1, 2, 3, 4, 5, 6], 10, true);
		animation.play('idle');
	}
	
}
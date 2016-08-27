package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	private var logoGroup:FlxSpriteGroup;
	private var newGame:FlxSprite;
	private var quit:FlxSprite;
	private var smallAvo:FlxSprite;
	
	private var selected:FlxSprite;
	
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFF333333;
		FlxG.camera.pixelPerfectRender = true;
		
		var largeAvo:FlxSprite = new FlxSprite(0, 0, 'assets/images/avocadolarge.png');
		largeAvo.antialiasing = true;
		var title:FlxSprite = new FlxSprite(largeAvo.x + (largeAvo.width + 12), largeAvo.y + 32, 'assets/images/title.png');
		
		logoGroup = new FlxSpriteGroup();
		logoGroup.add(largeAvo);
		logoGroup.add(title);
		logoGroup.x = (FlxG.width / 2) - (logoGroup.width / 2);
		logoGroup.y = (FlxG.height / 3) - (logoGroup.height / 2);
		
		newGame = new FlxSprite(logoGroup.x + (logoGroup.width / 2), logoGroup.y + logoGroup.height + 80, 'assets/images/newgame.png');
		newGame.x -= (newGame.width / 2);
		
		
		
		quit = new FlxSprite(newGame.x + (newGame.width / 2), newGame.y + newGame.height + 40, 'assets/images/quit.png');
		quit.x -= (quit.width / 2);
		
		smallAvo = new FlxSprite(0, 0, 'assets/images/avocadosmall.png');
		
		add(logoGroup);
		add(newGame);
		add(quit);
		add(smallAvo);
		
		selected = newGame;
		
		super.create();
	}
	
	private function buttonize(b:FlxSprite)
	{
		
		FlxG.mouse.getPosition();
	}

	override public function update(elapsed:Float):Void
	{
		if (newGame.overlapsPoint(FlxG.mouse.getPosition())) selected = newGame;
		else
		if (quit.overlapsPoint(FlxG.mouse.getPosition())) selected = quit;
		
		if (FlxG.mouse.justPressed)
		{
			if (selected == newGame) FlxG.switchState(new PlayState());
			else
			if (selected == quit) Sys.exit(0);
		}
		
		smallAvo.x = selected.x - smallAvo.width - 8;
		smallAvo.y = selected.y - 14;
		
		super.update(elapsed);
	}
}

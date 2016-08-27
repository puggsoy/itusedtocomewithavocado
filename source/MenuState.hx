package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

class MenuState extends FlxState
{
	private var logoGroup:FlxSpriteGroup;
	private var newGame:FlxSprite;
	private var quit:FlxSprite;
	private var smallAvo:FlxSprite;
	
	private var selected:FlxSprite;
	
	private var glitch:FlxGlitchEffect;
	private var glitchTimer:FlxTimer;
	
	private var tween:FlxTween;
	
	override public function create():Void
	{
		FlxG.mouse.useSystemCursor = true;
		FlxG.cameras.bgColor = 0xFF333333;
		FlxG.camera.pixelPerfectRender = true;
		
		glitch = new FlxGlitchEffect(6, 1, 0.01, HORIZONTAL);
		glitch.active = false;
		
		var largeAvo:FlxSprite = new FlxSprite(0, 0, 'assets/images/avocadolarge.png');
		var largeAvoEffect:FlxEffectSprite = new FlxEffectSprite(largeAvo, [glitch]);
		var title:FlxSprite = new FlxSprite(largeAvo.x + (largeAvo.width + 12), largeAvo.y + 32, 'assets/images/title.png');
		
		logoGroup = new FlxSpriteGroup();
		logoGroup.add(largeAvoEffect);
		logoGroup.add(title);
		logoGroup.x = (FlxG.width / 2) - (logoGroup.width / 2);
		logoGroup.y = (FlxG.height / 3) - (logoGroup.height / 2);
		
		tween = FlxTween.linearMotion(title, title.x, title.y - 20, title.x, title.y + 20, 2, true, {type: FlxTween.PINGPONG, ease: FlxEase.quadInOut});
		
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
		
		glitchTimer = new FlxTimer();
		glitchTimer.start(new FlxRandom().float(1, 4), periodicGlitch);
		
		//Music
		FlxG.sound.cacheAll();
		FlxG.sound.muted = false;
		FlxG.sound.playMusic('assets/music/mainmenu.ogg');
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		if (newGame.overlapsPoint(FlxG.mouse.getPosition())) selected = newGame;
		else
		if (quit.overlapsPoint(FlxG.mouse.getPosition())) selected = quit;
		
		if (FlxG.mouse.justPressed)
		{
			if (selected == newGame && newGame.overlapsPoint(FlxG.mouse.getPosition())) FlxG.switchState(new PlayState());
			else
			if (selected == quit && quit.overlapsPoint(FlxG.mouse.getPosition())) Sys.exit(0);
		}
		
		smallAvo.x = selected.x - smallAvo.width - 8;
		smallAvo.y = selected.y - 14;
		
		super.update(elapsed);
	}
	
	private function periodicGlitch(t:FlxTimer)
	{
		glitch.direction = new FlxRandom().bool() ? HORIZONTAL : VERTICAL;
		glitch.active = true;
		tween.active = false;
		FlxG.sound.music.pause();
		
		new FlxTimer().start(0.25, function(t:FlxTimer)
		{
			glitch.active = false;
			tween.active = true;
			FlxG.sound.music.resume();
			glitchTimer.start(new FlxRandom().float(1, 4), periodicGlitch);
		});
	}
}

package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

/**
 * ...
 * @author Sami
 */
class PauseState extends FlxSubState
{
	private var pauseMusic:FlxSound;
	
	public function new() 
	{
		super(FlxColor.TRANSPARENT);
		
		FlxG.sound.music.pause();
		pauseMusic = FlxG.sound.load('assets/music/pausemenu.ogg', 1, true, null, true, true);
		//pauseMusic.loadEmbedded('assets/music/pausemenu.ogg', true, true);
		//pauseMusic.play();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.ESCAPE) close();
		
		super.update(elapsed);
	}
	
	override public function close():Void 
	{
		FlxG.sound.music.resume();
		pauseMusic.stop();
		super.close();
	}
}
package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.Assets;

class PlayState extends FlxState
{
	private static inline var TILE_SIZE:Int = 32;
	private static inline var WIDTH_IN_TILES:Int = 200;
	private static inline var HEIGHT_IN_TILES:Int = 100;
	
	private static inline var TILES_FILE:String = 'assets/images/simple-tiles.png';
	private var levelFile:String = 'assets/data/lvl#.tmx';
	private var currentLevel:Int;
	
	private var map:Array<Array<Int>>;
	private var tileMap:FlxTilemap;
	
	private var player:Player;
	private var obstacles:FlxSpriteGroup;
	
	private var paused:Bool = false;
	
	public function new(level:Int = 1)
	{
		levelFile = StringTools.replace(levelFile, '#', Std.string(level));
		currentLevel = level;
		super();
	}
	
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFFFF00FF;
		
		var background:FlxSprite = new FlxSprite(0, 0, 'assets/images/parallax.png');
		background.scrollFactor.set(0.1, 0.06);
		add(background);
		
		loadLevel();
		
		add(player);
		FlxG.worldBounds.setSize(TILE_SIZE * WIDTH_IN_TILES, TILE_SIZE * HEIGHT_IN_TILES);
		FlxG.camera.setScrollBounds(0, TILE_SIZE * WIDTH_IN_TILES, 0, TILE_SIZE * HEIGHT_IN_TILES);
		FlxG.camera.follow(player);
		
		add(obstacles);
		
		FlxG.sound.playMusic('assets/music/ingame.ogg', 0.8);
		
		persistentUpdate = true;
		
		super.create();
		
		unpause();
	}
	
	private function loadLevel()
	{
		tileMap = new FlxTilemap();
		obstacles = new FlxSpriteGroup();
		player = new Player();
		
		var s:String = Assets.getText(levelFile);
		
		var mapXml:Xml = Xml.parse(s).firstElement();
		
		for (elem in mapXml.elements())
		{
			if (elem.nodeName == 'layer')
			{
				loadMap(elem.firstElement().firstChild().toString());
			}
			else
			if (elem.nodeName == 'objectgroup')
			{
				switch(elem.get('name').toLowerCase())
				{
					case 'player':
						loadPlayer(elem.firstElement());
					case 'smashers', 'sliders':
						loadObstacles(elem);
				}
			}
		}
	}
	
	private function loadMap(csv:String)
	{
		map = new Array<Array<Int>>();
		var lines:Array<String> = csv.split('\n');
		
		for (i in 0...lines.length)
		{
			if (map.length == HEIGHT_IN_TILES) break;
			
			var chars:Array<String> = lines[i].split(',');
			chars = chars.filter(function(s:String){ return s.length != 0; });
			
			if (chars.length < WIDTH_IN_TILES) continue;
			
			var row:Array<Int> = new Array<Int>();
			
			for (j in 0...WIDTH_IN_TILES)
			{
				if (chars.length == j) throw 'Not enough columns!';
				
				row[j] = Std.parseInt(chars[j]);
			}
			
			map.push(row);
		}
		
		tileMap.loadMapFrom2DArray(map, TILES_FILE, TILE_SIZE, TILE_SIZE, OFF, 1, 1, 1);
		add(tileMap);
	}
	
	private function loadPlayer(obj:Xml)
	{
		player.x = Std.parseFloat(obj.get('x'));
		player.y = Std.parseFloat(obj.get('y'));
	}
	
	private function loadObstacles(og:Xml)
	{
		for (elem in og.elements())
		{
			var ob:FlxSprite = null;
			
			switch(Std.parseInt(elem.get('gid')))
			{
				case 7:
					ob = new DownSmasher(Std.parseInt(elem.get('x')), Std.parseInt(elem.get('y')), tileMap);
				case 8:
					ob = new SideSmasher(Std.parseInt(elem.get('x')), Std.parseInt(elem.get('y')), tileMap);
				case 9:
					ob = new Slider(Std.parseInt(elem.get('x')), Std.parseInt(elem.get('y')), tileMap);
			}
			
			if(ob != null) obstacles.add(ob);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player, tileMap);
		FlxG.collide(player, obstacles);
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (subState == null)
			{
				pause();
				
				openSubState(new PauseState());
			}
			else
			{
				unpause();
				
				subState.close();
			}
		}
		else
		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new PlayState(currentLevel));
		}
	}
	
	private function pause()
	{
		paused = true;
		
		for (m in members)
		{
			m.active = true;
		}
		
		player.paused = true;
	}
	
	private function unpause()
	{
		paused = false;
		
		for (m in members)
		{
			m.active = false;
		}
		
		player.paused = false;
		player.active = true;
	}
	
	override public function switchTo(nextState:FlxState):Bool 
	{
		if(subState != null) subState.close();
		return super.switchTo(nextState);
	}
}

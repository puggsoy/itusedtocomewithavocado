package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
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
	
	private static inline var LEVEL_FILE:String = 'assets/data/lvl1.tmx';
	private static inline var TILES_FILE:String = 'assets/images/simple-tiles.png';
	
	private var map:Array<Array<Int>>;
	private var tileMap:FlxTilemap;
	
	private var player:Player;
	private var smashers:FlxSpriteGroup;
	
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFFCCCCCC;
		
		player = new Player();
		player.solid = true;
		
		loadLevel();
		
		add(player);
		FlxG.camera.setScrollBounds(0, TILE_SIZE * WIDTH_IN_TILES, 0, TILE_SIZE * HEIGHT_IN_TILES);
		FlxG.camera.follow(player);
		
		add(smashers);
		
		super.create();
	}
	
	private function loadLevel()
	{
		tileMap = new FlxTilemap();
		
		var s:String = Assets.getText(LEVEL_FILE);
		
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
					case 'smashers':
						loadSmashers(elem);
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
	
	private function loadSmashers(og:Xml)
	{
		smashers = new FlxSpriteGroup();
		
		for (elem in og.elements())
		{
			var sm:Smasher = new Smasher(Std.parseInt(elem.get('x')), Std.parseInt(elem.get('y')), tileMap);
			smashers.add(sm);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		FlxG.collide(player, tileMap);
		FlxG.collide(player, smashers);
		
		
		super.update(elapsed);
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.Assets;

class PlayState extends FlxState
{
	private static inline var TILE_SIZE:Int = 20;
	private static inline var WIDTH_IN_TILES:Int = 50;
	private static inline var HEIGHT_IN_TILES:Int = 20;
	
	private var player:Player;
	
	private var map:Array<Array<Int>>;
	private var tileMap:FlxTilemap;
	
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFFCCCCCC;
		
		player = new Player(10, 10);
		player.solid = true;
		
		generateLevel();
		
		super.create();
	}
	
	private function generateLevel()
	{
		tileMap = new FlxTilemap();
		
		Assets.loadText('assets/data/map.txt', function(s:String)
		{
			map = new Array<Array<Int>>();
			var lines:Array<String> = s.split('\n');
			
			for (i in 0...HEIGHT_IN_TILES)
			{
				map[i] = new Array<Int>();
				var chars:Array<String> = lines[i].split(',');
				
				for (j in 0...WIDTH_IN_TILES)
				{
					map[i][j] = Std.parseInt(chars[j]);
				}
			}
			
			tileMap.loadMapFrom2DArray(map, 'assets/images/simpletiles.png', TILE_SIZE, TILE_SIZE, OFF, 0, 1, 1);
			add(tileMap);
			
			add(player);
		});
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(tileMap, player);
		
		super.update(elapsed);
	}
}

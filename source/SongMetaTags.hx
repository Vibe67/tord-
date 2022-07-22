package;

#if sys
import sys.io.File;
#end

import flixel.FlxG;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;
using flixel.util.FlxSpriteUtil;

class SongMetaTags extends FlxSpriteGroup
{

    var meta:Array<Array<String>> = [];
    var size:Float = 0;
    var fontSize:Int = 24;
	var iconthingy:Credicon = new Credicon();

    public function new(_x:Float, _y:Float, _song:String, boner:String = 'Trans women rule') {

        super(_x, _y);

        var text = new FlxText(0, 0, 0, "", fontSize);
        text.setFormat(Paths.font("Eastwood.ttf"), fontSize, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        text.text = Assets.getText(Paths.txt(_song.toLowerCase() + "/creds"));

        size = text.fieldWidth;
        
        var bg = new FlxSprite(fontSize/-2, fontSize/-2).makeGraphic(Math.floor(size + fontSize + 152), Math.floor(text.height + fontSize + 72), FlxColor.BLACK);
        bg.alpha = 0.67;

        text.text += "\n";

        add(bg);
        add(text);

        if (boner == 'kalpy')
        {
            iconthingy = new Credicon(148, fontSize/-2, boner);
        } 
        else if (boner == 'MOTE')
        {
            iconthingy = new Credicon(220, fontSize/-2, boner);
        }
        else if (boner == 'Nate')
        {
            iconthingy = new Credicon(186, fontSize/-2, boner);
        }
        add(iconthingy);

        x -= size;
        visible = false;
    }

    public function start(){

        visible = true;

        FlxTween.tween(this, {x: x + size + (fontSize/2)}, 1, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween){
            FlxTween.tween(this, {x: x - size}, 1, {ease: FlxEase.quintIn, startDelay: 2, onComplete: function(twn:FlxTween){ this.destroy(); }});
        }});

    }
}

class Credicon extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0, iconname:String = 'JustJack')
	{
		super(x, y);
		loadGraphic(Paths.image('credits/' + iconname));
	}
}
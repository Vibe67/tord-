package; //Idk why I made this lmao 

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class AssetTest extends MusicBeatState
{
    var funnies:FlxSprite;
    var assetGroup:FlxTypedGroup<FlxSprite>;

    var editable:Bool = false; // DEBUG THING
    var editbleSprite:FlxSprite;
	var lpo:Int = 700;

    var assets:Array<String> = [
		'Burguer', 
		'kalpy',
		'Nate', 
		'Moxxie'
	];

    override public function create():Void
    {
        assetGroup = new FlxTypedGroup<FlxSprite>();
		add(assetGroup);

        for (i in 0...assets.length)
        {
            funnies = new FlxSprite((i * 160) + 271, 234).loadGraphic(Paths.image('credits/' + assets[i]));
            funnies.setGraphicSize(Std.int(140));
            funnies.updateHitbox();
            funnies.ID = i;
            assetGroup.add(funnies);
        }

        editbleSprite = funnies;
		editable = true;

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.keys.pressed.SHIFT && editable)
            {
                editbleSprite.x = FlxG.mouse.screenX;
                editbleSprite.y = FlxG.mouse.screenY;
            }
            else if (FlxG.keys.justPressed.C && editable)
            {
                trace(lpo);
                trace(editbleSprite);
            }
            else if (FlxG.keys.justPressed.E && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    lpo += 100;
                else
                    lpo += 15;
                editbleSprite.setGraphicSize(Std.int(lpo));
                editbleSprite.updateHitbox();
            }
            else if (FlxG.keys.justPressed.Q && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    lpo -= 100;
                else
                    lpo -= 15;
                editbleSprite.setGraphicSize(Std.int(lpo));
                editbleSprite.updateHitbox();
            }
            else if (FlxG.keys.justPressed.L && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    editbleSprite.x += 50;
                else
                    editbleSprite.x += 1;
            }
            else if (FlxG.keys.justPressed.K && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    editbleSprite.y += 50;
                else
                    editbleSprite.y += 1;
            }
            else if (FlxG.keys.justPressed.J && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    editbleSprite.x -= 50;
                else
                    editbleSprite.x -= 1;
            }
            else if (FlxG.keys.justPressed.I && editable)
            {
                if (FlxG.keys.pressed.ALT)
                    editbleSprite.y -= 50;
                else
                    editbleSprite.y -= 1;
            }

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }
}
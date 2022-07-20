package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var menuItem:FlxSprite;

	var checker:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/Checker'), 0.2, 0.2, true, true);
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var debugKeys:Array<FlxKey>;

	var editable:Bool = false; // DEBUG THING
    var editbleSprite:FlxSprite;
	var lpo:Int = 700;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		add(checker);
		checker.scrollFactor.set(0, 0.07);
		checker.angle = 45;

		var tord_bg:FlxSprite = new FlxSprite(801, 7).loadGraphic(Paths.image('mainmenu/Tord_BG'));
		tord_bg.setGraphicSize(Std.int(515));
		tord_bg.updateHitbox();
		add(tord_bg);

		var tord_bg4:FlxSprite = new FlxSprite(0, -10).loadGraphic(Paths.image('mainmenu/THICC_OUTLINE'));
		tord_bg4.setGraphicSize(Std.int(1305));
		tord_bg4.updateHitbox();
		add(tord_bg4);

		var tord_bg2:FlxSprite = new FlxSprite(-166, -20).loadGraphic(Paths.image('mainmenu/Layer_9'));
		tord_bg2.setGraphicSize(Std.int(1235));
		tord_bg2.updateHitbox();
		add(tord_bg2);
	
		var tord_bg3:FlxSprite = new FlxSprite(0, 340).loadGraphic(Paths.image('mainmenu/Layer_10'));
		tord_bg3.setGraphicSize(Std.int(475));
		tord_bg3.updateHitbox();
		add(tord_bg3);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.7;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			menuItem = new FlxSprite(0, (i * 140)  + offset).loadGraphic(Paths.image('mainmenu/menu_' + optionShit[i]));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.ID = i;
			switch (i)
			{
				case 0: 
					menuItem.x = 70;
					menuItem.y = 10;
				case 1:
					menuItem.x = 20;
					menuItem.y = 170;
				case 2:
					menuItem.x = 50;
					menuItem.y = 360;
					menuItem.scale.x = 0.5;
					menuItem.scale.y = 0.5;
				case 3:
					menuItem.x = 140;
					menuItem.y = 410;
					menuItem.scale.x = 0.5;
					menuItem.scale.y = 0.5;
			}
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		var tord:FlxSprite = new FlxSprite(765, -10).loadGraphic(Paths.image('mainmenu/Tord'));
		tord.setGraphicSize(Std.int(550));
		tord.updateHitbox();
		add(tord);

		FlxTween.tween(tord,{y: tord.y -15}, 1.5, {type:FlxTween.PINGPONG});

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		editbleSprite = menuItem;
		editable = false;

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		checker.x += 1.5 / (120 / 60);
		checker.y += 1.5 / (120 / 60);

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

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		//camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();
			spr.alpha = 0.7;

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
				spr.alpha = 1;
			}
		});
	}
}

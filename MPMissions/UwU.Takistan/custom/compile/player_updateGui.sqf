private ["_display","_ctrlBlood","_ctrlBleed","_bloodVal","_humanityName","_ctrlFood","_ctrlThirst","_thirstVal","_foodVal","_ctrlTemp","_tempVal","_combatVal","_array","_ctrlEar","_ctrlEye",
"_ctrlCombat","_ctrlFracture","_visualText","_visual","_audibleText","_audible","_blood","_thirstLvl","_foodLvl","_tempImg","_thirst","_food","_temp","_bloodLvl","_tempLvl","_color","_string",
"_humanity","_size","_friendlies","_rfriendlies","_rfriendlyTo","_distance","_targetControl","_playerUID","_rplayerUID","_humanityTarget","_ctrlBloodOuter","_ctrlFoodBorder","_ctrlThirstBorder",
"_ctrlTempBorder","_ctrlRank","_humRank","_ctrlRankText"];
disableSerialization;

_foodVal = 		1 - (dayz_hunger / SleepFood);
_thirstVal = 	1 - (dayz_thirst / SleepWater);
_tempVal 	= 	1 - ((dayz_temperatur - dayz_temperaturmin)/(dayz_temperaturmax - dayz_temperaturmin));	// Normalise to [0,1]
_combatVal =	1 - dayz_combat; // May change later to be a range of red/green to loosely indicate 'time left in combat'

if (uiNamespace getVariable ["DZ_displayUI", 0] == 1) exitWith {
	_array = [_foodVal,_thirstVal];
	_array
};

_display = uiNamespace getVariable 'DAYZ_GUI_display';
_ctrlBloodOuter = _display displayCtrl 1200;
_ctrlFoodBorder = _display displayCtrl 1201;
_ctrlThirstBorder = _display displayCtrl 1202;
_ctrlTempBorder = _display displayCtrl 1208;
//Border white
_ctrlBloodOuter ctrlSetTextColor [1,1,1,1];
_ctrlFoodBorder ctrlSetTextColor [1,1,1,1];
_ctrlThirstBorder ctrlSetTextColor [1,1,1,1];
_ctrlTempBorder ctrlSetTextColor [1,1,1,1];

_ctrlBlood = 	_display displayCtrl 1300;
_ctrlBleed = 	_display displayCtrl 1303;
_bloodVal =		r_player_blood / r_player_bloodTotal;
_ctrlFood = 	_display displayCtrl 1301;
_ctrlThirst = 	_display displayCtrl 1302;
_ctrlTemp 	= 	_display displayCtrl 1306;					//TeeChange
_ctrlEar = 		_display displayCtrl 1304;
_ctrlEye = 		_display displayCtrl 1305;
//_ctrlHumanity = _display displayCtrl 1207;
_ctrlCombat = _display displayCtrl 1307;
_ctrlFracture = 	_display displayCtrl 1203;
_ctrlRank =		_display displayCtrl 1311;
_ctrlRankText = _display displayCtrl 1312;

_ctrlBloodAmount = _display displayCtrl 1420;
_ctrlHumanityAmount = _display displayCtrl 1421;
_ctrlServerRestart = _display displayCtrl 1422;

_bloodTotal = round((r_player_blood/12000)*100);

_RestartTime = (count playableUnits);
_humRank = player getVariable['humanity', 0];
// NO RANK
if(_humRank < 5000 && _humRank > -5000) then {_ctrlRank ctrlSetText ""; _ctrlRankText ctrlSetText "";};
// HERO RANK
if(_humRank >= 5000 && _humRank < 10000) then {_ctrlRank ctrlSetText "custom\interface\Rank1.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 1"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 10000 && _humRank < 15000) then {_ctrlRank ctrlSetText "custom\interface\Rank2.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 2"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 15000 && _humRank < 25000) then {_ctrlRank ctrlSetText "custom\interface\Rank3.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 3"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 25000 && _humRank < 40000) then {_ctrlRank ctrlSetText "custom\interface\Rank4.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 4"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 40000 && _humRank < 60000) then {_ctrlRank ctrlSetText "custom\interface\Rank5.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 5"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 60000 && _humRank < 90000) then {_ctrlRank ctrlSetText "custom\interface\Rank6.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 6"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 90000 && _humRank < 130000) then {_ctrlRank ctrlSetText "custom\interface\Rank7.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 7"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 130000 && _humRank < 185000) then {_ctrlRank ctrlSetText "custom\interface\Rank8.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 8"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 185000 && _humRank < 250000) then {_ctrlRank ctrlSetText "custom\interface\Rank9.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 9"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
if(_humRank >= 250000) then {_ctrlRank ctrlSetText "custom\interface\Rank10.paa"; _ctrlRankText ctrlSetText "[HERO] Rank 10"; _ctrlRankText ctrlSetTextColor [1, 1, 0, 1.0];};
// BANDIT RANK
if(_humRank <= -5000 && _humRank > -10000) then {_ctrlRank ctrlSetText "custom\interface\Rank1.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 1"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -10000 && _humRank > -15000) then {_ctrlRank ctrlSetText "custom\interface\Rank2.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 2"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -15000 && _humRank > -25000) then {_ctrlRank ctrlSetText "custom\interface\Rank3.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 3"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -25000 && _humRank > -40000) then {_ctrlRank ctrlSetText "custom\interface\Rank4.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 4"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -40000 && _humRank > -60000) then {_ctrlRank ctrlSetText "custom\interface\Rank5.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 5"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -60000 && _humRank > -90000) then {_ctrlRank ctrlSetText "custom\interface\Rank6.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 6"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -90000 && _humRank > -130000) then {_ctrlRank ctrlSetText "custom\interface\Rank7.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 7"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -130000 && _humRank > -185000) then {_ctrlRank ctrlSetText "custom\interface\Rank8.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 8"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -185000 && _humRank > -250000) then {_ctrlRank ctrlSetText "custom\interface\Rank9.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 9"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};
if(_humRank <= -250000) then {_ctrlRank ctrlSetText "custom\interface\Rank10.paa"; _ctrlRankText ctrlSetText "[BANDIT] Rank 10"; _ctrlRankText ctrlSetTextColor [0.75, 0, 0, 1.0];};


_ctrlBloodAmount      ctrlSetText str(_bloodTotal);
_ctrlHumanityAmount ctrlSetText str(player getVariable['humanity', 0]);
_ctrlServerRestart  ctrlSetText str(_RestartTime);

_ctrlFPS = _display displayCtrl 1321;
_ctrlFPSOuter = _display displayCtrl 1322;

_fps = round diag_FPS;
_ctrlFPS ctrlSetText str(_fps);
_ctrlFPS ctrlSetTextColor [0.6, 0.73, 0.0, 0.75];

_ctrlhumanKills = _display displayCtrl 1400;
_ctrlbanditKills= _display displayCtrl 1402;
_ctrlzombieKills= _display displayCtrl 1403;

_ctrlhumanKills  ctrlSetText str(player getVariable["humanKills", 0]);
_ctrlbanditKills ctrlSetText str(player getVariable["banditKills", 0]);
_ctrlzombieKills ctrlSetText str(player getVariable["zombieKills", 0]);

//Food/Water/Blood
_ctrlBlood ctrlSetTextColor 	[(Dayz_GUI_R + (0.3 * (1-_bloodVal))),(Dayz_GUI_G * _bloodVal),(Dayz_GUI_B * _bloodVal), 0.5];
_ctrlFood ctrlSetTextColor 		[(Dayz_GUI_R + (0.3 * (1-_foodVal))),(Dayz_GUI_G * _foodVal),(Dayz_GUI_B * _foodVal), 0.5];
_ctrlThirst ctrlSetTextColor 	[(Dayz_GUI_R + (0.3 * (1-_thirstVal))),(Dayz_GUI_G * _thirstVal),(Dayz_GUI_B * _thirstVal), 0.5];
_ctrlTemp ctrlSetTextColor 		[(Dayz_GUI_R + (0.3 * (1-_tempVal))), (Dayz_GUI_G * _tempVal), _tempVal, 0.5];	// Color ranges from iceblue (cold) to red (hot)
_ctrlCombat ctrlSetTextColor		[(Dayz_GUI_R + (0.3 * (1-_combatVal))),(Dayz_GUI_G * _combatVal),(Dayz_GUI_B * _combatVal), 0.5];

/*
	Blood: round((r_player_blood / 2) / 1000) = _bloodLvl (6 = full, 1 = empty)
	Thirst: round(_thirstVal / 0.25) = _thirstLvl (4 = full, 0 = empty)
	Hunger: round(_foodVal / 0.25) = _foodLvl (4 = full, 0 = empty)
	Temp: round(dayz_temperatur) = tempLvl (>= 36 = full <= 28 = empty)
*/

_blood = "";
_thirst = "";
_food = "";
_temp = "";
_tempImg = 0;
_bloodLvl = round((r_player_blood / 2) / 1000);
_thirstLvl = round(_thirstVal / 0.25);
_foodLvl = round(_foodVal / 0.25);
_tempLvl = round(dayz_temperatur);

/*
diag_log format["DEBUG: bloodlvl: %1 r_player_blood: %2 bloodval: %3",_bloodLvl, r_player_blood, _bloodVal];
diag_log format["DEBUG: thirstlvl: %1 dayz_thirst: %2 thirstval: %3",_thirstLvl, dayz_thirst, _thirstVal];
diag_log format["DEBUG: foodlvl: %1 dayz_hunger: %2 foodval: %3",_foodLvl, dayz_hunger, _foodVal];
diag_log format["DEBUG: templvl: %1 dayz_temperatur: %2 tempval: %3",_tempLvl, dayz_temperatur, _tempVal];
*/

if (_bloodLvl <= 0) then { 
	_blood = "\z\addons\dayz_code\gui\status_blood_inside_1_ca.paa";
	} else {
	_blood = "\z\addons\dayz_code\gui\status_blood_inside_" + str(_bloodLvl) + "_ca.paa";
	};

if (_thirstLvl < 0) then { _thirstLvl = 0 };
_thirst = "\z\addons\dayz_code\gui\status_thirst_inside_" + str(_thirstLvl) + "_ca.paa";

if (_foodLvl < 0) then { _foodLvl = 0 };
_food = "\z\addons\dayz_code\gui\status_food_inside_" + str(_foodLvl) + "_ca.paa";

if ( _tempLvl >= 36 )							then { _tempImg = 4 };
if ( _tempLvl > 33 && _tempLvl < 36 )			then { _tempImg = 3 };
if ( _tempLvl >= 30 && _tempLvl <= 33 )		then { _tempImg = 2 };
if ( _tempLvl > 28 && _tempLvl < 30 )			then { _tempImg = 1 };
if ( _tempLvl <= 28 )							then { _tempImg = 0 };

_temp = "\z\addons\dayz_code\gui\status_temp_" + str(_tempImg) + "_ca.paa";

_ctrlBlood ctrlSetText _blood;
_ctrlThirst ctrlSetText _thirst;
_ctrlFood ctrlSetText _food;
_ctrlTemp ctrlSetText _temp;

/*
	Visual:
*/
//_visualtext = "";
//    _visual = (round((dayz_disVisual / 100) * 4)) min 5;
//if (_visual > 0) then {_visualtext = "\z\addons\dayz_code\gui\val_" + str(_visual) + "_ca.paa"};
//_ctrlEye ctrlSetText _visualtext;
_visual = (dayz_disVisual / 185) min 1;
if (_visual < 0.2) then {_visual = 0.2;};
_ctrlEye  ctrlSetTextColor [1, 1, 1, _visual];

/*
	Audible:
*/
//_audibletext = "";
//    _audible = (round((dayz_disAudial / 50) * 4)) min 5;
//if (_audible > 0) then {_audibletext = "\z\addons\dayz_code\gui\val_" + str(_audible) + "_ca.paa"};
//_ctrlEar ctrlSetText _audibletext;
_audible = (dayz_disAudial / 40) min 1;
if (_audible < 0.2) then {_audible = 0.2;};
_ctrlEar ctrlSetTextColor [1, 1, 1, _audible];

/*
	Fracture:
*/
if (!canStand player) then {
	if (!(ctrlShown _ctrlFracture)) then {
		r_fracture_legs = true;
		_ctrlFracture ctrlShow true;
	};
};

/*
	Flashing:
*/
if (_combatVal == 0) then {
	_ctrlCombat call player_guiControlFlash;
};

if (_bloodVal < 0.2) then {
	_ctrlBlood call player_guiControlFlash;
};

if (_thirstVal < 0.2) then {
	_ctrlThirst call player_guiControlFlash;
};

if (_foodVal < 0.2) then {
	_ctrlFood call player_guiControlFlash;
};

if (_tempVal > 0.8) then {	//TeeChange
	_ctrlTemp call player_guiControlFlash;
} else {
	_ctrlTemp ctrlShow true;
};

if (r_player_injured) then {
	_ctrlBleed call player_guiControlFlash;
};

/*
Opt-in tag system with friend tagging
*/
_string = "";
_humanityTarget = cursorTarget;
if (!isNull _humanityTarget && isPlayer _humanityTarget && alive _humanityTarget) then {

	_distance = player distance _humanityTarget;

	if (_distance < DZE_HumanityTargetDistance) then {
		
		_size = (1-(floor(_distance/5)*0.1)) max 0.1;

		// Display name if player opt-in || if friend
		_friendlies = player getVariable ["friendlies", []];
		
		_playerUID = [player] call FNC_GetPlayerUID;
		_rplayerUID = [_humanityTarget] call FNC_GetPlayerUID;
		
		_rfriendlies = _humanityTarget getVariable ["friendlies", []];
		_rfriendlyTo = _humanityTarget getVariable ["friendlyTo", []];

		if ((_rplayerUID in _friendlies) && (_playerUID in _rfriendlies)) then {

			if !(_playerUID in _rfriendlyTo) then {
				// diag_log format["IS FRIENDLY: %1", _player];
				_rfriendlyTo set [count _rfriendlyTo, _playerUID];
				_humanityTarget setVariable ["friendlyTo", _rfriendlyTo, true];
			};
	
			// <br /><t %2 align='center' size='0.7'>Humanity: %3</t>

			_color = "color='#339933'";
			_string = format["<t %2 align='center' size='%3'>%1</t>",(name _humanityTarget),_color,_size];
		
		} else {

			// Humanity checks
			_humanity = _humanityTarget getVariable ["humanity",0];

			_color = "color='#ffffff'";
			if(_humanity < -5000) then {
				_color = "color='#ff0000'";
			} else {
				if(_humanity > 5000) then {
					_color = "color='#3333ff'";
				};
			};
			if((_humanityTarget getVariable ["DZE_display_name", false]) || (DZE_ForceNameTagsInTrader && isInTraderCity)) then {
				_string = format["<t %2 align='center' size='%3'>%1</t>",(name _humanityTarget),_color,_size];
			};
		};
	};
};

// update gui if changed
if (dayz_humanitytarget != _string) then {
	_targetControl = _display displayCtrl 1199;
	_targetControl ctrlSetStructuredText (parseText _string);
	dayz_humanitytarget = _string;
};

_array = [_foodVal,_thirstVal];
_array
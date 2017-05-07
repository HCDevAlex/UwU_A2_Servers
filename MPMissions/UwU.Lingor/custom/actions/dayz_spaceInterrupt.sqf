private ["_dikCode","_handled","_primaryWeapon","_secondaryWeapon","_nearbyObjects","_nill","_shift","_ctrl","_alt","_dropPrimary","_dropSecondary","_iItem","_removed","_iPos","_radius","_item",
"_findNearestPoles","_IsNearPlot","_fuid","_allowed","_playerUID","_thePlot","_owner","_friends","_friendUID","_position"];
_dikCode = 	_this select 1;
GlobalPreviewVariable = 1;
_handled = false;

if ((animationState player) in ["smk_urbanproneright","smk_prone_to_urbanprone_right","smk_urbanproneleft","smk_prone_to_urbanprone_left"]) then {
	player switchMove "";
	player playActionNow "Down";
	cutText ["\n\nUrban prone stances have been disabled.", "PLAIN DOWN"];
	_findNearestPoles = nearestObjects[player, ["Plastic_Pole_EP1_DZ"], DZE_PlotPole select 0];
	_IsNearPlot = count (_findNearestPoles);
	_fuid  = [];
	_allowed = [];
	if(_IsNearPlot > 0)then{
		_playerUID = [player] call FNC_GetPlayerUID;
		_thePlot = _findNearestPoles select 0;
		_owner =  _thePlot getVariable ["ownerPUID","010"];
		_friends = _thePlot getVariable ["plotfriends", []];
		{
		  _friendUID = _x select 0;
		  _fuid  =  _fuid  + [_friendUID];
		} forEach _friends;
		_allowed = [_owner];    
		_allowed = [_owner] +  _fuid;	
		if (!(_playerUID in _allowed)) then {
			_position = getPos player;
			["========================================================================================"] call remote_log;
			[format["-----------------URBAN PRONE------------------: %1 [%2] used urban prone near a players base owned by [%3] at (%3,%4)", name player,_playerUID,_owner, _position Select 0, _position Select 1]] call remote_log;
			["========================================================================================"] call remote_log;
		};
	};
};

if (_dikCode in[0x02,0x03,0x04,0x58,0x57,0x44,0x43,0x42,0x41,0x40,0x3F,0x3E,0x3D,0x3C,0x3B,0x0B,0x0A,0x09,0x08,0x07,0x06,0x05]) then {
	_handled = true;
};

if ((_dikCode == 0x3E || _dikCode == 0x0F || _dikCode == 0xD3)) then {
	if(diag_tickTime - dayz_lastCheckBit > 10) then {
		dayz_lastCheckBit = diag_tickTime;
		call dayz_forceSave;
	};
	call dayz_EjectPlayer;
};

// esc
if (_dikCode == 0x01) then {
	_nill = execvm "custom\actions\esc.sqf";
	DZE_cancelBuilding = true;
	call dayz_EjectPlayer;
};
// Disable ESC after death
if (_dikCode == 0x01 && r_player_dead) then {
	_handled = true;
};

// surrender 
if (_dikCode in actionKeys "Surrender") then {
	
	_vehicle = vehicle player;
	_inVehicle = (_vehicle != player);
	_onLadder =	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
	_canDo = (!r_drag_sqf && !r_player_unconscious && !_onLadder && !_inVehicle);
	
	if (_canDo && !DZE_Surrender && !(player isKindOf  "PZombie_VB")) then {
		DZE_Surrender = true;
		_dropPrimary = false;
		_dropSecondary = false;

		_primaryWeapon = primaryWeapon player;
		if (_primaryWeapon != "") then {_dropPrimary = true;};
		_secondaryWeapon = "";
		{
			if ((getNumber (configFile >> "CfgWeapons" >> _x >> "Type")) == 2) exitWith {
					_secondaryWeapon = _x;
			};
		} count (weapons player);
		if (_secondaryWeapon != "") then {_dropSecondary = true;};

		if (_dropPrimary || _dropSecondary) then {
			player playActionNow "PutDown";
			_iPos = getPosATL player;
			_radius = 1;
			_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
			_item setposATL _iPos;
			if (_dropPrimary) then {
				_iItem = _primaryWeapon;
				_removed = ([player,_iItem,1] call BIS_fnc_invRemove);
				if (_removed == 1) then {
					_item addWeaponCargoGlobal [_iItem,1];
				};
			};
			if (_dropSecondary) then {
				_iItem = _secondaryWeapon;
				_removed = ([player,_iItem,1] call BIS_fnc_invRemove);
				if (_removed == 1) then {
					_item addWeaponCargoGlobal [_iItem,1];
				};
			};
			player reveal _item;
		};

		// set publicvariable that allows other player to access gear
		player setVariable ["DZE_Surrendered", true, true];
		// surrender animation
		player playMove "AmovPercMstpSsurWnonDnon";
	};
	_handled = true;
};

if (_dikCode in actionKeys "MoveForward") exitWith {r_interrupt = true; if (DZE_Surrender) then {call dze_surrender_off};};
if (_dikCode in actionKeys "MoveLeft") exitWith {r_interrupt = true; if (DZE_Surrender) then {call dze_surrender_off};};
if (_dikCode in actionKeys "MoveRight") exitWith {r_interrupt = true; if (DZE_Surrender) then {call dze_surrender_off};};
if (_dikCode in actionKeys "MoveBack") exitWith {r_interrupt = true; if (DZE_Surrender) then {call dze_surrender_off};};

//Prevent exploit of glitching through doors
if (_dikCode in actionKeys "Prone") then {
	_doors = (position player) nearEntities [DZE_DoorsLocked, 3];
	if (count _doors > 0) then {
		_handled = true;
	};
};

//Prevent exploit of drag body
if ((_dikCode in actionKeys "Prone") && r_drag_sqf) exitWith { force_dropBody = true; };
if ((_dikCode in actionKeys "Crouch") && r_drag_sqf) exitWith { force_dropBody = true; };

_shift = 	_this select 2;
_ctrl = 	_this select 3;
_alt =		_this select 4;

//diag_log format["Keypress: %1", _this];
if ((_dikCode in actionKeys "Gear") && (vehicle player != player) && !_shift && !_ctrl && !_alt && !dialog) then {
			createGearDialog [player, "RscDisplayGear"];
			_handled = true;
};

if (_dikCode in (actionKeys "GetOver")) then {
	
	if (player isKindOf  "PZombie_VB") then {
		_handled = true;
		DZE_PZATTACK = true;
	} else {
		_nearbyObjects = (position player) nearEntities [dayz_disallowedVault, 8];
		if (count _nearbyObjects > 0) then {
			if((diag_tickTime - dayz_lastCheckBit > 4)) then {
				[objNull, player, rSwitchMove,"GetOver"] call RE;
				player playActionNow "GetOver";
				dayz_lastCheckBit = diag_tickTime;
			} else {
				_handled = true;
			};
		};
	};
};
//if (_dikCode == 57) then {_handled = true}; // space
//if (_dikCode in actionKeys 'MoveForward' || _dikCode in actionKeys 'MoveBack') then {r_interrupt = true};
if (_dikCode == 210) then {
		_nill = execvm "\z\addons\dayz_code\actions\playerstats.sqf";
};

if (_dikCode in actionKeys "ForceCommandingMode") then {_handled = true};
if (_dikCode in actionKeys "PushToTalk" && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	[player,50,true,(getPosATL player)] spawn player_alertZombies;
};
if (_dikCode in actionKeys "VoiceOverNet" && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	[player,50,true,(getPosATL player)] spawn player_alertZombies;
};
if (_dikCode in actionKeys "PushToTalkDirect" && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	[player,15,false,(getPosATL player)] spawn player_alertZombies;
};
if (_dikCode in actionKeys "Chat" && (diag_tickTime - dayz_lastCheckBit > 10)) then {
	dayz_lastCheckBit = diag_tickTime;
	[player,15,false,(getPosATL player)] spawn player_alertZombies;
};
if (_dikCode in actionKeys "User20" && (diag_tickTime - dayz_lastCheckBit > 5)) then {
	dayz_lastCheckBit = diag_tickTime;
	_nill = execvm "\z\addons\dayz_code\actions\playerstats.sqf";
};

// numpad 8 0x48 now pgup 0xC9 1
if ((_dikCode == 0xC9 && (!_alt || !_ctrl)) || (_dikCode in actionKeys "User15")) then {
	DZE_Q = true;
};
// numpad 2 0x50 now pgdn 0xD1
if ((_dikCode == 0xD1 && (!_alt || !_ctrl)) || (_dikCode in actionKeys "User16")) then {
	DZE_Z = true;
};


// numpad 8 0x48 now pgup 0xC9 0.1
if ((_dikCode == 0xC9 && (_alt && !_ctrl)) || (_dikCode in actionKeys "User13")) then {
	DZE_Q_alt = true;
};
// numpad 2 0x50 now pgdn 0xD1
if ((_dikCode == 0xD1 && (_alt && !_ctrl)) || (_dikCode in actionKeys "User14")) then {
	DZE_Z_alt = true;
};


// numpad 8 0x48 now pgup 0xC9 0.01
if ((_dikCode == 0xC9 && (!_alt && _ctrl)) || (_dikCode in actionKeys "User7")) then {
	DZE_Q_ctrl = true;
};
// numpad 2 0x50 now pgdn 0xD1
if ((_dikCode == 0xD1 && (!_alt && _ctrl)) || (_dikCode in actionKeys "User8")) then {
	DZE_Z_ctrl = true;
};




// numpad 4 0x4B now Q 0x10
if (_dikCode == 0x10 || (_dikCode in actionKeys "User17")) then {
	DZE_4 = true;
};		
// numpad 6 0x4D now E 0x12
if (_dikCode == 0x12 || (_dikCode in actionKeys "User18")) then {
	DZE_6 = true;
};
// numpad 5 0x4C now space 0x39
if (_dikCode == 0x39 || (_dikCode in actionKeys "User19")) then {
	DZE_5 = true;
};
// num 1, 2 or 3 above qwerty
if (_dikCode == 0x02) then {
	AAC_1 = true;
};
if (_dikCode == 0x03) then {
	AAC_2 = true;
};
if (_dikCode == 0x04) then {
	AAC_3 = true;
};

// F key
if ((_dikCode == 0x21 && (!_alt && !_ctrl)) || (_dikCode in actionKeys "User6")) then {
	DZE_F = true;
};

if (_dikCode == 0xDC) then {
    if (tagName) then {tagName = false;titleText ["Group name tags OFF","PLAIN DOWN"];titleFadeOut 4;} else {tagName = true;titleText ["Group name tags ON","PLAIN DOWN"];titleFadeOut 4;};
    _handled = true;
};

if (_dikCode == 0xDB) then {
    if (dialog) then {closeDialog 0;groupManagementActive = false;} else {execVM "custom\addons\dzgm\loadGroupManagement.sqf";};
    _handled = true;
};

if (_dikCode in actionKeys "TacticalView") then {_handled = true;};

if (_dikCode == 0xB8) then {
    [] execVM "custom\addons\menu\actionmenu_main.sqf";
};

//open backpack on H button
if (_dikCode == 0x23) then {
	if (isNil "OpenGear") then {
		(findDisplay 106) closeDisplay 1;
		player action ["gear", unitBackpack player];
		OpenGear = true;
		} else {
		(findDisplay 106) closeDisplay 1;
		OpenGear = nil;
	};
	_handled = true;
};

_handled

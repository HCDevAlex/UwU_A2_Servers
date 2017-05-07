
private ["_gearmenu","_playerPos","_nearWeed","_weed","_objectID","_objectUID","_onLadder","_vehicle","_inVehicle","_playernear"];
_playerPos = getPosATL player;
_nearWeed = count nearestObjects [_playerPos, ["fiberplant"], 4] > 0;
_weed = nearestObject [player, "fiberplant"];
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf && !r_player_unconscious && !_onLadder);
_vehicle = vehicle player;
_inVehicle = (_vehicle != player);

if !(_nearWeed) exitWith {
	cutText [format["You need to be near the weed plants in order to harvest."], "PLAIN DOWN"];
};
if !(_canDo) exitWith {
	cutText [format["Error: You cannot harvest weed."], "PLAIN DOWN"];
};
if (_inVehicle) exitWith {
	cutText [format["You cannot harvest Weed While in a vehicle"], "PLAIN DOWN"];
};

if (dayz_combat == 1) then { 
    cutText [format["You are in Combat and Cannot harvest the Weed."], "PLAIN DOWN"];
} else {
	disableSerialization;
	_gearmenu = FindDisplay 106;
	_gearmenu CloseDisplay 106;
	if !(_nearWeed) exitWith {
	cutText [format["You need to be near the weed plants in order to harvest."], "PLAIN DOWN"];
	};
	_objectID = _weed getVariable["ObjectID","0"];
	_objectUID = _weed getVariable["ObjectUID","0"];
	deleteVehicle _weed;
	[_objectID,_objectUID] call server_deleteObj;
	_weed setDamage 1;
	[10,10] call dayz_HungerThirst;
	player playActionNow "Medic";
	r_interrupt = false;
	sleep 5;
	[10,10] call dayz_HungerThirst;
	player playActionNow "Medic";
	sleep 5;
	player addMagazine "ItemKiloHemp";
	sleep 2;
	cutText [format["You've Gathered Some Weed! Sell it!!"], "PLAIN DOWN"];	
};
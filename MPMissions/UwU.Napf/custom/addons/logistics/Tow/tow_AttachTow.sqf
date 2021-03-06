private ["_towing","_vehicle","_started","_finished","_animState","_isMedic","_abort","_vehicleNameText","_towTruckNameText","_findNearestVehicles","_findNearestVehicle","_IsNearVehicle","_towTruck","_towableVehicles","_towableVehiclesTotal","_vehicleOffsetY","_towTruckOffsetX","_towTruckOffsetY","_offsetZ","_hasToolbox","_searchLoc","_location1","_location2","_facing","_behind"];

if(DZE_ActionInProgress) exitWith { cutText [(localize "str_epoch_player_96") , "PLAIN DOWN"] };

DZE_ActionInProgress = true;

player removeAction s_player_towing;
s_player_towing = 1;

// Tow Truck
_towTruck = _this select 3;
_towableVehicles = [_towTruck] call MF_Tow_Towable_Array;
_towableVehiclesTotal = count (_towableVehicles);
_towTruckNameText = [_towTruck] call MF_Tow_Get_Vehicle_Name;
_towTruckX = getPosATL _towTruck select 0;
_towTruckY = getPosATL _towTruck select 1;
_towTruckDir = getDir _towTruck;
_towOffset = (boundingBox _towTruck select 1 select 1) / 2;

// select the nearest vehicle behind us
_findNearestVehicle = [];
for "_i" from _towOffset to MF_Tow_Distance + _towOffset do {
	_towTruckRelX = (sin (_towTruckDir + 180)) * _i;
	_towTruckRelY = (cos (_towTruckDir + 180)) * _i;
	_searchLoc = [_towTruckX + _towTruckRelX, _towTruckY + _towTruckRelY, 0];
	_findNearestVehicles = nearestObjects [_searchLoc, _towableVehicles, 8];
	{
		if (alive _x && _towTruck != _x) then {
			_findNearestVehicle set [(count _findNearestVehicle),_x];
		};
	} foreach _findNearestVehicles;
	if (count _findNearestVehicle > 0) exitWith { };	
};

if(count _findNearestVehicle > 0) then {
	_vehicle = _findNearestVehicle select 0;
	_towableVehicleDir = getDir _vehicle;
	_vehicleNameText = [_vehicle] call MF_Tow_Get_Vehicle_Name;
	_hasToolbox = "ItemToolbox" in (items player);
	_towVector = vectorDir _towTruck;
	_vehVector = vectorDir _vehicle;
	_difference = (_towVector select 0) * (_vehVector select 0) + (_towVector select 1) * (_vehVector select 1);
	_facing = (_difference < 1 && _difference > .85);
	_towVector = vectorDir _towTruck;
	_vehVector = vectorDir _vehicle;
	_difference = (_towVector select 0) * (_vehVector select 0) + (_towVector select 1) * (_vehVector select 1);
	diag_log(format ["Difference: %1", _difference]);
	_facing = ((_towableVehicleDir > _towTruckDir - 25) && (_towableVehicleDir < _towTruckDir + 25));
	_towableVehicleX = getPosATL _vehicle select 0;
	_towableVehicleY = getPosATL _vehicle select 1;
	_towableOffset = (boundingBox _vehicle select 1 select 1) / 2;
	_towOffset = (boundingBox _towTruck select 1 select 1);
	_maxTowDistance = MF_Tow_Distance + (_towableOffset * 2);
	
	for "_i" from _towOffset to MF_Tow_Distance * 6 do {
		_towTruckRelX = (sin (_towTruckDir + 180)) * _i / 8;
		_towTruckRelY = (cos (_towTruckDir + 180)) * _i / 8;
		_towableRelX = (sin (_towableVehicleDir)) * _i / 8;
		_towableRelY = (cos (_towableVehicleDir)) * _i / 8;
		_location1 = [_towTruckX + _towTruckRelX, _towTruckY + _towTruckRelY, 0];
		_location2 = [_towableVehicleX + _towableRelX, _towableVehicleY + _towableRelY, 0];
		_behind = (_location1 distance _location2 < 2);
		if (_behind) exitWith {};
	};
	
	if(!_hasToolbox) exitWith { cutText ["Cannot attach tow without a toolbox.", "PLAIN DOWN"];}; // Check the player has a toolbox
	if(!_behind) exitWith { cutText[ format["%1 must be behind %2 to tow.", _vehicleNameText, _towTruckNameText], "PLAIN DOWN"];}; // Check for vehicle behind tow vehicle
	if(!_facing) exitWith { cutText[ format["%1 must be facing %2 to tow.", _vehicleNameText, _towTruckNameText, _towTruckDir, _towableVehicleDir], "PLAIN DOWN"];}; // Check for vehicle behind tow vehicle
	if(locked _towTruck) exitWith { cutText [format["Cannot tow with %1 because it is locked.", _towTruckNameText], "PLAIN DOWN"];}; // Check if the vehicle we are towing with is locked
	if((_vehicle getVariable ["MF_Tow_Cannot_Tow", false]) || (locked _vehicle)) exitWith { cutText [format["Cannot tow %1 because it is locked.", _vehicleNameText], "PLAIN DOWN"];}; // Check if the vehicle we want to tow is locked
	//if !(MF_Tow_Multi_Towing) then {
		if (_towTruck getVariable ["MFTowInTow", false]) exitWith { cutText [format["Cannot tow with %1 because it is already being towed by another vehicle.", _towTruckNameText], "PLAIN DOWN"];}; // Check that the vehicle we want to tow is not already being towed by something else.
		if (_vehicle getVariable ["MFTowIsTowing", false]) exitWith { cutText [format["Cannot tow %1 because it is already towing another vehicle.", _vehicleNameText], "PLAIN DOWN"];}; // Check that the vehicle we want to tow is not already towing something else
	//};
	if ((count (crew _vehicle)) != 0) exitWith { cutText [format["Cannot tow %1 because it has people in it.", _vehicleNameText], "PLAIN DOWN"];}; // Check if the vehicle has anyone in it
	
	_finished = false;
	[_towTruck] call MF_Tow_Animate_Player_Tow_Action;
	r_interrupt = false;
	_animState = animationState player;
	r_doLoop = true;
	_started = false;
	cutText [format["Start tow %1...", _vehicleNameText], "PLAIN DOWN"];

	while {r_doLoop} do {
		_animState = animationState player;
		_isMedic = ["medic",_animState] call fnc_inString;
		if (_isMedic) then {
			_started = true;
		};
		
		if (_started and !_isMedic) then {
			r_doLoop = false;
			_finished = true;
		};
		
		// Check if anyone enters the vehicle while we are attaching the tow and stop the action
		if ((count (crew _vehicle)) != 0) then {
			cutText [format["Towing aborted because the %1 was entered by another player.", _vehicleNameText], "PLAIN DOWN"];
			r_interrupt = true;
		};
		
		if (r_interrupt) then {
			detach player;
			r_doLoop = false;
		};
		
		sleep 0.1;
	};
	r_doLoop = false;

	if(!_finished) then {
		r_interrupt = false;
			
		if (vehicle player == player) then {
			[objNull, player, rSwitchMove,""] call RE;
			player playActionNow "stop";
		};
		_abort = true;
	};

	if (_finished) then {
		if(((vectorUp _vehicle) select 2) > 0.5) then {
			if( _towableVehiclesTotal > 0 ) then {
				_towTruckOffsetX = 0;
				_towTruckOffsetY = 0.8;
				_vehicleOffsetY = 0.8;
				_offsetZ = 0.1;
				
				// Calculate the offset positions depending on the kind of tow truck				
				switch(true) do {
					case (_towTruck isKindOf "ArmoredSUV_Base_PMC");
					case (_towTruck isKindOf "SUV_Base_EP1") : {
						_towTruckOffsetY = 0.9;
					};
					case (_towTruck isKindOf "UAZ_Base" && !(_vehicle isKindOf "UAZ_Base")) : {
						_offsetZ = 1.8;
					};
					case (_towTruck isKindOf "TowingTractor") : {
						_towTruckOffsetX = .3;
					};
					case (_towTruck isKindOf "BMP3") : {
						_towTruckOffsetX = -1.3;
					};
				};
				
				// Calculate the offset positions depending on the kind of vehicle
				switch(true) do {
					case (_vehicle isKindOf "Truck" && !(_towTruck isKindOf "Truck")) : {
						_vehicleOffsetY = 0.9;
					};
					case (_vehicle isKindOf "C130J_US_EP1_DZ") : { // done
						_vehicleOffsetY = .8;
						_offsetZ = -.95;
					};
					case (_vehicle isKindOf "AN2_DZ") : { // done
						_vehicleOffsetY = .7;
						_offsetZ = -.45;
					};
					case (_vehicle isKindOf "CH_47F_EP1_DZE") : { // done
						_vehicleOffsetY = .45;
						_offsetZ = -.6;
					};
					case (_vehicle isKindOf "CH53_DZE") : { // done
						_vehicleOffsetY = .35;
						_offsetZ = -9.4;
					};
					case (_vehicle isKindOf "Mi17_Civilian_DZ") : {
						_vehicleOffsetY = .5;
						_offsetZ = -.5;
					};
					case (_vehicle isKindOf "UH60M_EP1_DZE") : { // done
						_vehicleOffsetY = .6;
						_offsetZ = -.3;
					};
					case (_vehicle isKindOf "UH1H_DZE") : { // done
						_vehicleOffsetY = .6;
						_offsetZ = -.2;
					};
					case (_vehicle isKindOf "UH1Y_DZE") : { // done
						_vehicleOffsetY = .05;
						_offsetZ = -.2;
					};
					case (_vehicle isKindOf "MH6J_DZ") : { // done
						_vehicleOffsetY = .6;
						_offsetZ = -.2;
					};
					case (_vehicle isKindOf "MV22_DZ") : { // done
						_vehicleOffsetY = .6;
						_offsetZ = -.85;
					};
					case (_vehicle isKindOf "UAZ_MG_CDF") : { // done
						_offsetZ = -.1;
					};
					case (_vehicle isKindOf "UAZ_Base" && !(_towTruck isKindOf "UAZ_Base") && !(_vehicle isKindOf "UAZ_MG_CDF")) : {
						_offsetZ = -1.8;
					};
					case (_vehicle isKindOf "350z") : { // done	
						_offsetZ = -0.85;
					};
					case (_towTruck isKindOf "350z") : { // Always Last
						_offsetZ = _offsetZ + 0.85;
					};
				};
					
				// Attach the vehicle to the tow truck
				_vehicle attachTo [ _towTruck,
					[
						_towTruckOffsetX,
						(boundingBox _towTruck select 0 select 1) * _towTruckOffsetY + (boundingBox _vehicle select 0 select 1) * _vehicleOffsetY,
						(boundingBox _towTruck select 0 select 2) - (boundingBox _vehicle select 0 select 2) + _offsetZ
					]
				];
				
				_vehicle addEventHandler ["GetIn", {
				if (_this select 0 getVariable ["VehicleInTow", true]) then {
					player action ["eject", _this select 0];
					cutText [format["Can`t sit in a car if car towing"], "PLAIN DOWN"];
				};}];
				
				_vehicle setVariable ["VehicleInTow", true, true];
				if !(MF_Tow_Multi_Towing_BTC) then {
					_vehicle setVariable ["BTC_Cannot_Lift",true,true];
					_towTruck setVariable ["BTC_Cannot_Lift",true,true];
				};
				_vehicle setVariable ["MFTowInTow", true, true];
				_towTruck setVariable ["MFTowIsTowing", true, true];
				_towTruck setVariable ["MFTowVehicleInTow", _vehicle, true];
				
				cutText [format["%1 has been attached to %2.", _vehicleNameText, _towTruckNameText], "PLAIN DOWN"];
			};	
		} else {
			cutText [format["Failed to attach %1 to %2.", _vehicleNameText, _towTruckNameText], "PLAIN DOWN"];
		};
	};
} else {
	cutText [format["No vehicles nearby to tow. Move within %1m of a vehicle.", MF_Tow_Distance], "PLAIN DOWN"];
};
DZE_ActionInProgress = false;
player removeAction s_player_towing;
s_player_towing = -1;
if(isServer) then {
	
	private ["_i","_traders","_safepos","_validspot","_position"];

	civ_markerready = false;

	if(use_blacklist) then {
		_safepos		= [getMarkerPos "center",0,8500,(_this select 0),0,0.5,0,blacklist];
	} else {
		_safepos		= [getMarkerPos "center",0,8500,(_this select 0),0,0.5,0];
	};

	_validspot 	= false;
	_i 			= 1;

	while{!_validspot} do {
	
		sleep 1;

		_position 	= _safepos call BIS_fnc_findSafePos;
		_i 			= _i + 1;
		_validspot	= true;

		if (_position call inDebug) then { if(debug_mode) then {diag_log("CAI: Invalid Position (Debug)");}; _validspot = false; }; 

		if(_validspot && cai_avoid_water != 0) then {
			if ([_position,cai_avoid_water] call civ_isNearWater) then { if(debug_mode) then {diag_log("CAI: Invalid Position (Water)");}; _validspot = false; }; 
		};

		if (_validspot && isNil "infiSTAR_LoadStatus1" && cai_avoid_town != 0) then {
			if ([_position,cai_avoid_town] call civ_isNearTown) then {  if(debug_mode) then {diag_log("CAI: Invalid Position (Town)");}; _validspot = false; };
		}; // ELSE infoSTAR is enabled, need to find another method of finding near towns

		if(_validspot && cai_avoid_road != 0) then {
			if ([_position,cai_avoid_road] call civ_isNearRoad) then { if(debug_mode) then {diag_log("CAI: Invalid Position (Road)");}; _validspot = false; };
		};
		
		if(_validspot && cai_avoid_plot != 0) then {
			if ([_position,cai_avoid_plot] call civ_isNearPlot) then { if(debug_mode) then {diag_log("CAI: Invalid Position (Plot Pole)");}; _validspot = false; };
		};
		
		if(_validspot && cai_avoid_slope != 0) then {
			if ([_position,cai_avoid_slope,cai_avoid_slopeGradient] call civ_isSlope) then { if(debug_mode) then {diag_log("CAI: Invalid Position (Slope)");}; _validspot = false; };
		};

		if (_validspot && cai_avoid_missions != 0) then {
			if(debug_mode) then { diag_log("CAI DEBUG: FINDPOS: Checking nearby mission markers: " + str(cai_mission_markers)); };
			{
				if (getMarkerColor _x != "" && (_position distance (getMarkerPos _x) < cai_avoid_missions)) exitWith { if(debug_mode) then {diag_log("CAI: Invalid Position (Marker: " + str(_x) + ")");}; _validspot = false; };
			} count cai_mission_markers;
		};

		if (_validspot && cai_avoid_traders != 0) then {
			if(debug_mode) then { diag_log("CAI DEBUG: FINDPOS: Checking nearby trader markers: " + str(trader_markers)); };
			{
				if (getMarkerColor _x != "" && (_position distance (getMarkerPos _x) < cai_avoid_traders)) exitWith { if(debug_mode) then {diag_log("CAI: Invalid Position (Marker: " + str(_x) + ")");}; _validspot = false; };
			} count civ_trader_markers;
		};

		if(_validspot) then {

			if(debug_mode) then { diag_log("Loop complete, valid position " +str(_position) + " in " + str(_i) + " attempts"); };
	
		};

	};
	_position set [2, 0];
	_position
};
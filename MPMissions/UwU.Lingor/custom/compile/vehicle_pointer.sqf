//
// Jahan Vehicle Pointer v0.1 - Masterkey mod compatible version (jahangir13 - 11/2014)
// [email protected]
/*  */

// Shows you vehicles belonging to a key if in 1st search range. If not shows them on map (if allowed via config).
//
private ["_markerNames","_i","_j","_arrow1","_arrow2","_arrow3","_arrow4","_arrow5","_light1","_light2","_light3","_light4","_light5","_vehsNearFound","_vehsNearNotFound","_vehDistance","_showMarkerSearchText","_inventoryItems","_rNum""_name","_mark","_showMarkerType","_showMarkerColor","_showMarkerShape","_showMarkerSize","_showMarkerSearchText","_showFlareType","_showFlareOthers","_flare","_light","_showTime","_showMarkerTime","_showSign","_signHeight","_showOthers","_scanRadius","_scanRadius2","_showVehMapMarker","_vehTarget","_arrow","_vehsAround","_keyOwner","_x","_keyName","_ownerID","_vehFoundInRange","_classname","_vehDisplayName","_positionArrow","_location","_inventoryItems"];

//###############################################################################################################################################
// Configuration Options:
//
/////// Sign showing above vehicle
// How long should the sign be shown above the vehicle (in seconds)
_showTime = 5;
// Classname of the sign to show above the car (here red arrow.  Or "testsphere1" ... whatever)
_showSign = "Sign_arrow_down_large_EP1";
// How high above the vehicle the sign shows up (in meters)
_signHeight = 2;
// Shall the sign above the vehicle be seen by others (if false can only be seen by the player)
_showSignOthers = false;
// 1st Range radius to scan for vehicles near the player (should not be too far...as you need to see it) / 2nd range _scanRadius2 for the bigger map marker scan (should cover whole map)
_scanRadius = 80;
_scanRadius2 = 25000;
//
/////// Flare coming down over vehicle (That's for those who like special effects ,) ).
_showFlare = true;
// Show flare to others (false: only player can see the flare)
_showFlareOthers = false;
// The height over map the flare is starting. (The higher the longer it takes to come down.)
_showFlareHeight = 50;
// The type of the flair (classname). Also possible (maybe others too): 
_showFlareType = "F_40mm_White";
//
/////// Marker showing on Map
// Show vehicle on map if nothing was found in first scan doing an extended search (true: show marker on map / false: don't show marker on map)
_showVehMapMarker = true;
// Time the marker stays on the map (in seconds)
_showMarkerTime = 20;
// Color of the map marker ( https://community.bistudio.com/wiki/setMarkerColorLocal )
_showMarkerColor = "ColorRedAlpha"; 
// Type of the map marker (icon on map / E.g.: https://community.bistudio.com/wikidata/images/e/ea/Arma2_markers4.jpg)
_showMarkerType = "Artillery";
// Shape of the marker ( "ICON", "RECTANGLE" or "ELLIPSE" are possible )
_showMarkerShape = "ICON";
// Size of the marker ( Size is in format [a-axis, b-axis]. Depends on which marker type is chosen. )
_showMarkerSize = [3,3];
// Text which shows up behind the marker in the map (after the ': ' the vehicle name is showing.)
_showMarkerSearchText = "Search:";
// Shall the map marker be seen by others (if false can only be seen by the player. Could make some fun if others could see where someone is looking for the vehicle ,) )
_showMarkerOthers = true;
//###############################################################################################################################################

// get key Owner from ui_selectSlot.sqf
_keyOwner = _this select 0;
_keyName = _this select 1;

// variable to remember if vehicle has been found in range
_vehFoundInRange = false;
// The target vehicle which belong to the key
_vehTarget = objNull;

//---------------------------------------------------------------------------------------------------------    
// compare with vehicles around
// array to store vehicles found (could be more than one if masterkey script is used)
systemChat format ["JVP: >>>>>"];
systemChat format ["JVP: Searching for Vehicles in near range..."];
_vehsNearFound = [];
_vehsAround = nearestObjects [getPos player, ["Plane","LandVehicle","Helicopter","Ship"], _scanRadius];
{
    _ownerID = _x getVariable ["CharacterID", "0"];
    if ( _keyOwner == _ownerID ) then {
        _vehFoundInRange = true; 
		_vehsNearFound = _vehsNearFound + [_x];
	};
} forEach _vehsAround;
//---------------------------------------------------------------------------------------------------------    	
    
// if vehicle has been found in range show marker above vehicle
if (_vehFoundInRange) then {
    _i = 0;
	// for all found vehicles in near range
	{
        _vehTarget = _x;
		_classname = typeOf _vehTarget;
		_vehDisplayName = gettext (configFile >> "CfgVehicles" >> (typeof _vehTarget) >> "displayName");
        _i = _i + 1;
		systemChat format ["JVP: %1 belongs to %2 found in range. Mark with Arrow...",_keyName, _vehDisplayName];	
		// create the sign which shows up above the target vehicle
		_location = position _vehTarget;
		_positionArrow = _vehTarget modelToWorld [0,0,2];

		// local or globally visible
		if (_showSignOthers) then {
			_arrow = createVehicle [_showSign, _location, [], 0, "NONE"];
			_light = "#lightpoint" createVehicle [0,0,0];
		} else {
			_arrow = _showSign createVehicleLocal _location;
			_light = "#lightpoint" createVehicleLocal [0,0,0];
		};
        _lightname = format ["light%1", _i];
        _light setVehicleVarName _lightname;
        call compile format["%1 = _light", _lightname];
        _arrowname = format ["arrow%1", _i];
        _arrow setVehicleVarName _arrowname;
        call compile format["%1 = _arrow", _arrowname];
        
        _arrow setVehiclePosition [_positionArrow, [], 0];
	    _arrow attachTo [_vehTarget,[0,0,_signHeight],""];
        
        // Create the light effect
		_light setLightBrightness 0.01;
		_light setLightAmbient[1.0, 1.0, 1.0];
		_light setLightColor[1.0, 1.0, 1.0];
		_light lightAttachObject [_vehTarget, [0,0,1]];
        
		if ( _showFlare ) then {
			if ( _showFlareOthers ) then {
				_flare = _showFlareType createVehicle [getPos _vehTarget select 0, getPos _vehTarget select 1, _showFlareHeight];
			} else {
				_flare = _showFlareType createVehicleLocal [getPos _vehTarget select 0, getPos _vehTarget select 1, _showFlareHeight];
			};
		};

        } forEach _vehsNearFound;
        
        systemChat format ["JVP: <<<<<"];
        
		// Show the sign that long above the vehicle
		sleep _showTime;

		// Delete the Sign again
        for "_j" from 1 to _i do {
            deleteVehicle call compile format ["arrow%1", _j];  
            // Turn off the light.
            deletevehicle call compile format ["light%1", _j];
        };
	
// if vehicle has not been found in range search in wider range and set marker on map (if config option allows that)    
};

///// Marker stuff for vehicles not found in the near range
    
    // exit if marker config set to 'false'
    if !( _showVehMapMarker ) exitWith { };
    
    // exit if no map or gps in the players inventory
    _inventoryItems = [player] call BIS_fnc_invString;
    if ( !("ItemGPS" in _inventoryItems) && !("ItemMap" in _inventoryItems) ) exitWith {systemChat "JVP: You need a Map or GPS to see the markers! Exit.";};
    
    systemChat format ["JVP: Searching for Vehicles in wider range..."];
    //---------------------------------------------------------------------------------------------------------    
    // Do the bigger search (whole map)
    _vehFoundInRange = false; 
    _vehsFarFound = [];
    _vehsAround = nearestObjects [getPos player, ["Plane","LandVehicle","Helicopter","Ship"], _scanRadius2];
    {
        _ownerID = _x getVariable ["CharacterID", "0"];
        if ( _keyOwner == _ownerID ) then {
            _vehFoundInRange = true; 
            _vehsFarFound = _vehsFarFound + [_x];
        };
    } forEach _vehsAround;
    // delete vehicles from array where we've already showed the arrow sign
    _vehsFarFound = _vehsFarFound - _vehsNearFound;
    //---------------------------------------------------------------------------------------------------------    
    
    if (_vehFoundInRange) then {
    
        _markerNames = [];
        _i = 0;
        {
            _i = _i + 1;
            _vehTarget = _x;
            _classname = typeOf _vehTarget;
            _vehDisplayName = gettext (configFile >> "CfgVehicles" >> (typeof _vehTarget) >> "displayName");
            _vehDistance = floor (player distance _vehTarget);
            systemChat format ["JVP: %1 belongs to %2 found in range. Show on map...",_keyName, _vehDisplayName];
        
            _location = position _vehTarget;
            // Get the vehicle display name from config
            _vehDisplayName = gettext (configFile >> "CfgVehicles" >> (typeof _vehTarget) >> "displayName");
            // Create the map marker: http://forums.bistudio.com/showthread.php?135013-Marker-that-created-with-createMarkerLocal-can-seen-by-everyone
            // random number for map marker name needs to be unique:
            _rNum = floor random 10;
            _name = format ["Search: %1" + " [%2]", _vehDisplayName, _rNum];
            // store markername in array
            _markerNames = _markerNames + [_name];
            
            // local or globally visible
            if ( _showMarkerOthers ) then {
                _mark = createMarker [_name, _location];
                _name setMarkerShape _showMarkerShape;
                _name setMarkerType _showMarkerType;
                _name setMarkerColor _showMarkerColor;
                _name setMarkerSize _showMarkerSize;
                _name setMarkerAlpha 1;
                _name setMarkerText format [_showMarkerSearchText + " " + "%1", _vehDisplayName];
                //Marker stays this time on map
            } else {
                _mark = createMarkerLocal [_name, _location];
                _name setMarkerShapeLocal _showMarkerShape;
                _name setMarkerTypeLocal _showMarkerType;
                _name setMarkerColorLocal _showMarkerColor;
                _name setMarkerSizeLocal _showMarkerSize;
                _name setMarkerAlphaLocal 1;
                _name setMarkerTextLocal format [_showMarkerSearchText + " " + "%1" + " " + "[%2 m]", _vehDisplayName, _vehDistance];
            };
        
        } forEach _vehsFarFound;
        
        systemChat format ["JVP: <<<<<"];
        
        sleep _showMarkerTime;
        // Delete map marker again
        {
            deleteMarker _x;
        } forEach _markerNames;
        
    } else {
        systemChat format ["JVP: %1 does not belong to any vehicle in big search range.", _keyName];
        systemChat format ["JVP: <<<<<"];
    };
disableSerialization;
while {true} do
{
1000 cutRsc ["AsReMixhud","PLAIN"];
_wpui = uiNameSpace getVariable "AsReMixhud";
_vitals = _wpui displayCtrl 4900;
_thePlayer = player;
_cashMoney  = _thePlayer getVariable["cashMoney",0];
_vitals ctrlSetStructuredText parseText format ["<img size='1.4' align='left' image='custom\interface\Money.paa'/><t size='0.9'> %1 </t>   <br/>",[_cashMoney] call BIS_fnc_numberText];
_vitals ctrlCommit 0;     
uiSleep 2;
};

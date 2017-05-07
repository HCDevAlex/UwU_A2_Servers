_bodyCheck = -1; // If a player has a body within this distance of a spawn that spawn will be blocked. Set to -1 to disable.
_mapRadius = 14400; // Distance from center to farthest edge of map. Only used when spawnNearPlot is enabled.
_spawnNearGroup = true; // Allow players to spawn near their group. Blocked if the player has a body within bodyCheck distance of the leader. Requires DZGM to work.
_spawnNearPlot = false; // Allow players to spawn near their plot. Blocked if the player has a body within bodyCheck distance of their plot. Requires Plot4Life to work. 
_spawnRadius = 800; // Distance around spawn to find a safe pos. Lower is closer to exact coordinates. Do not set too low or BIS_fnc_findSafePos may fail.

_spawnPoints = [
		["Random",[[1698.2728, 608.19336, 0],[1203.9924, 592.44324, 0],[534.57129, 931.08551, 0],[971.86395, 1766.6132, 0],[2104.4998, 1086.9586, 0],[2896.8037, 1324.5605, 0],[3286.209, 1515.5829, 0],[3828.3474, 1472.7954, 0],[4297.3359, 1690.4199, 0],[4705.125, 1870.5652, 0],[4060.7, 2345.0037, 0],[3421.1252, 3766.6194, 0],[1922.6033, 4517.4087, 0],[927.57318, 5021.5088, 0],[856.64136, 5598.0586, 0],[2785.6826, 5370.9512, 0],[3405.3394, 5096.249, 0],[4011.7578, 5033.6431, 0],[4791.3721, 5078.8423, 0],[4149.0122, 4544.4688, 0],[3711.9893, 4556.1895, 0],[3144.592, 4587.4668, 0],[4723.3696, 3143.2578, 0],[3585.9399, 2795.4971, 0],[4913.4629, 2696.5176, 0],[5436.3374, 2104.5081, 0],[5597.6309, 3267.8198, 0],[6621.3857, 3326.3127, 0],[6811.1563, 2144.3533, 0],[7500.8418, 1913.8586, 0],[7671.9023, 2902.4526, 0],[8318.8057, 2860.9172, 0],[6069.5698, 1760.6586, 0],[5827.6191, 4638.3301, 0],[6808.8735, 4703.7256, 0],[6589.0029, 4349.2559, 0],[7016.9897, 5735.5288, 0],[6418.1719, 5793.4741, 0],[6587.939, 6538.291, 0],[6099.6914, 6766.8203, 0],[8637.2393, 7845.1719, 0],[8372.5771, 8785.4121, 0],[5118.2563, 6945.5122, 0],[4364.9629, 6769.4038, 0],[3687.0007, 6459.0557, 0],[3923.0681, 5904.8486, 0],[4467.5986, 5669.1431, 0],[5187.9038, 5476.7856, 0],[5398.9761, 5077.6099, 0],[3275.8403, 6209.2446, 0],[3045.7483, 6477.4067, 0],[2758.9204, 6864.7163, 0],[3091.5913, 8037.5361, 0],[1364.8784, 1412.1613, 0],[648.92084, 4687.8394, 0],[3081.7029, 5971.0171, 0],[6869.2939, 6409.1436, 0],[528.13885, 1397.0074, 0],[4418.1411, 4931.6899, 0],[6819.8062, 6067.6177, 0],[6560.959, 6837.7388, 0],[4455.2627, 6040.2598, 0],[4027.7668, 9277.6094, 0],[3247.5833, 9433.7051, 0],[1286.6865, 7435.5381, 0],[913.44141, 8188.9297, 0],[9286.9316, 4032.8284, 0],[9243.4004, 5055.9131, 0],[1935.9822, 8777.6797, 0],[2522.0386, 9178.0166, 0],[832.84277, 7705.6685, 0]],0,0,1],
		["Medlina", [1698.2728, 608.19336, 0],0,0],
		["Alma", [1203.9924, 592.44324, 0],0,0],
		["Mercadio", [534.57129, 931.08551, 0],0,0],
		["Drassen", [971.86395, 1766.6132, 0],0,0],
		["Verto", [2104.4998, 1086.9586, 0],0,0],
		["Rock Cafe", [2896.8037, 1324.5605, 0],0,0],
		["Ralon", [3286.209, 1515.5829, 0],0,0],
		["Calamar", [3828.3474, 1472.7954, 0],0,0],
		["Sargento", [4297.3359, 1690.4199, 0],0,0],
		["Melana Resort", [4705.125, 1870.5652, 0],0,0],
		["Bilbado", [4060.7, 2345.0037, 0],0,0],
		["Research Lab 102", [3421.1252, 3766.6194, 0],0,0],
		["Motodrom Rapido", [1922.6033, 4517.4087, 0],0,0],
		["Regina Tributa", [927.57318, 5021.5088, 0],0,0],
		["Benio", [856.64136, 5598.0586, 0],0,0],
		["Vidora", [2785.6826, 5370.9512, 0],0,0],
		["Rosalia", [3405.3394, 5096.249, 0],0,0],
		["Distrito Turistico", [4011.7578, 5033.6431, 0],0,0],
		["Calapedro", [4791.3721, 5078.8423, 0],0,0],
		["San Arulco", [4149.0122, 4544.4688, 0],0,0],
		["Centro Esencia", [3711.9893, 4556.1895, 0],0,0],
		["Morada", [3144.592, 4587.4668, 0],0,0],
		["Faunaverde", [4723.3696, 3143.2578, 0],0,0],
		["Montehofo", [3585.9399, 2795.4971, 0],0,0],
		["Negrosa", [4913.4629, 2696.5176, 0],0,0],
		["Lagosa", [5436.3374, 2104.5081, 0],0,0],
		["Prospero", [5597.6309, 3267.8198, 0],0,0],
		["Victorin", [6621.3857, 3326.3127, 0],0,0],
		["Marcella", [6811.1563, 2144.3533, 0],0,0],
		["El Villon", [7500.8418, 1913.8586, 0],0,0],
		["Monga-Tamba-Pachi", [7671.9023, 2902.4526, 0],0,0],
		["Palida", [8318.8057, 2860.9172, 0],0,0],
		["Building", [6069.5698, 1760.6586, 0],0,0],
		["Corazon", [5827.6191, 4638.3301, 0],0,0],
		["Manteria", [6808.8735, 4703.7256, 0],0,0],
		["Sanvigado", [6589.0029, 4349.2559, 0],0,0],
		["Cafe Prada South", [7016.9897, 5735.5288, 0],0,0],
		["Tres Palmas Inn", [6418.1719, 5793.4741, 0],0,0],
		["Maruko", [6587.939, 6538.291, 0],0,0],
		["Airport Terminal (West)", [6099.6914, 6766.8203, 0],0,0],
		["Conoteta", [8637.2393, 7845.1719, 0],0,0],
		["Cemarin", [8372.5771, 8785.4121, 0],0,0],
		["San Isabel", [5118.2563, 6945.5122, 0],0,0],
		["Research Lab 101", [4364.9629, 6769.4038, 0],0,0],
		["Aculto-Garibosa", [3687.0007, 6459.0557, 0],0,0],
		["Gayucca", [3923.0681, 5904.8486, 0],0,0],
		["Tucos", [4467.5986, 5669.1431, 0],0,0],
		["Barracks", [5187.9038, 5476.7856, 0],0,0],
		["Checkpoint Oeste", [5398.9761, 5077.6099, 0],0,0],
		["Calixo", [3275.8403, 6209.2446, 0],0,0],
		["FOB Eddie", [3045.7483, 6477.4067, 0],0,0],
		["FOB Eddie 2", [2758.9204, 6864.7163, 0],0,0],
		["Prison", [3091.5913, 8037.5361, 0],0,0],
		["Pintosa", [1364.8784, 1412.1613, 0],0,0],
		["Villa Oscura", [648.92084, 4687.8394, 0],0,0],
		["Fernando", [3081.7029, 5971.0171, 0],0,0],
		["Presidente Palace", [6869.2939, 6409.1436, 0],0,0],
		["Zuela", [528.13885, 1397.0074, 0],0,0],
		["Zona Residencial", [4418.1411, 4931.6899, 0],0,0],
		["Cafe Prada", [6819.8062, 6067.6177, 0],0,0],
		["Airport Terminal (East)", [6560.959, 6837.7388, 0],0,0],
		["Tucos (North)", [4455.2627, 6040.2598, 0],0,0],
		["Gatoro", [4027.7668, 9277.6094, 0],0,0],
		["Medicolin", [3247.5833, 9433.7051, 0],0,0],
		["Zanjeer", [1286.6865, 7435.5381, 0],0,0],
		["Arapesca", [913.44141, 8188.9297, 0],0,0],
		["Fantasmo", [9286.9316, 4032.8284, 0],0,0],
		["Bantanam North", [9243.4004, 5055.9131, 0],0,0],
		["North Military Base 1", [1935.9822, 8777.6797, 0],0,0],
		["North Military Base 2", [2522.0386, 9178.0166, 0],0,0],
		["North Military Base 3", [832.84277, 7705.6685, 0],0,0]
		];
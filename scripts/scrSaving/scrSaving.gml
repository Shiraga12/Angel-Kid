#macro jsonNAME "angelkid.json"
#macro compatibilityVERSION 0

function defaultSAVE()
{
	var struct =
	{
		COMPATIBILITY_VERSION: compatibilityVERSION,
		
		WORLD: 0,
		STAGE: 0,
		CLEARED_WORLDS: [],
		CLEARED_STAGES: []
	};
	
	for (var i = 0; i < worlds.count; i++) { struct.CLEARED_STAGES[i] = []; }
	
	return struct;
}

function jsonSAVE(data = global.SAVE, fileName = jsonNAME)
{
    var save_string = json_stringify(data, true);
    var save_buffer = buffer_create(string_byte_length(save_string) + 1, buffer_fixed, 1);
	
    buffer_write(save_buffer, buffer_string, save_string);
    buffer_save(save_buffer, fileName);
    buffer_delete(save_buffer);
}

function jsonLOAD(fileName = jsonNAME) 
{
    if !file_exists(fileName) return;
   
    var load_buffer = buffer_load(fileName);
	if load_buffer == -1 { return {}; }
	
    var load_string = buffer_read(load_buffer, buffer_string);
	
    buffer_delete(load_buffer);
	return json_parse(load_string);
}
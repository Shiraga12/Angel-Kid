///@desc Methods

///@func recursiveMERGE(value, default)
recursiveMERGE = function(value, _default)
{
	value = variable_clone(value);
	
	if is_undefined(value) { return _default; }
	if ((is_array(value) && !is_array(_default)) || (!is_array(value) && is_array(_default))) { return _default; }
	if ((is_struct(value) && !is_struct(_default)) || (!is_struct(value) && is_struct(_default))) { return _default; }
	
	if is_array(_default)
	{
		for (var i = 0; i < array_length(_default); i++)
		{
			if i >= array_length(value) { break; }
			value[i] = recursiveMERGE(value[i], _default[i]);
		}
		
		return value;
	}
	
	if is_struct(_default)
	{
		var _default_names = struct_get_names(_default);
		for (var i = 0; i < array_length(_default_names); i++)
		{
			value[$ _default_names[i]] = recursiveMERGE(value[$ _default_names[i]],
				_default[$ _default_names[i]]);
		}
		
		return value;
	}
	
	return value;
}

///@func loadJSON_SAFE([fileName], [defaultSave], [compatibilityFUNCTIONS])
loadJSON_SAFE = function(fileName = jsonNAME, defaultSave = defaultSAVE(), compatibilityFUNCTIONS = [])
{
	var struct = {};
	if file_exists(fileName) struct = jsonLOAD(fileName);
	
	var names = struct_get_names(defaultSave);
	for (var i = 0; i < array_length(names); i++)
	{
		var _default = defaultSave[$ names[i]];
		struct[$ names[i]] = recursiveMERGE(struct[$ names[i]], _default);
	}
	
	for (var i = struct.COMPATIBILITY_VERSION; i < array_length(compatibilityFUNCTIONS); i++)
	{
		if i < 0 { break; }
	
		compatibilityFUNCTIONS[i]();
		struct.COMPATIBILITY_VERSION++;
	}
	
	//Save again with the extra default values
	jsonSAVE(struct, fileName);
	return struct;
}
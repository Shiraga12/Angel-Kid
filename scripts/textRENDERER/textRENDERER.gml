/// @description Parses a string with embedded tags into an array of tokens for rendering.
/// @param {string} _str The string to parse.
function text_parse(_str) {
	var _tokens = [];
	var _buffer = "";
	var _i = 1;
	var _len = string_length(_str);

	while (_i <= _len) {
		var _ch = string_char_at(_str, _i);

		if (_ch == "[") {
			var _end = _i + 1;

			while (_end <= _len && string_char_at(_str, _end) != "]") {
				_end++;
			}

			if (_end <= _len) {
				if (_buffer != "") {
					array_push(_tokens, { type: "TEXT", value: _buffer });
					_buffer = "";
				}

				var _tag = string_copy(_str, _i + 1, _end - _i - 1);
				array_push(_tokens, text_parse_tag(_tag));

				_i = _end + 1;
				continue;
			}
		}

		_buffer += _ch;
		_i++;
	}

	if (_buffer != "") {
		array_push(_tokens, { type: "TEXT", value: _buffer });
	}

	return _tokens;
}
/// @description Parses a tag string into a structured object representing the tag type and its arguments.
/// @param {string} _tag The tag string to parse (without the surrounding brackets).
function text_parse_tag(_tag) {
	_tag = string_trim(_tag);

	if (string_char_at(_tag, 1) == "/") {
		var _close = string_upper(string_trim(string_delete(_tag, 1, 1)));

		if (_close == "") _close = "ALL";

		return {
			type: "CLOSE",
			close: _close,
			args: []
		};
	}

	var _colon = string_pos(":", _tag);

	if (_colon <= 0) {
		return {
			type: string_upper(_tag),
			args: []
		};
	}

	var _type = string_upper(string_trim(string_copy(_tag, 1, _colon - 1)));
	var _arg_string = string_trim(string_copy(_tag, _colon + 1, string_length(_tag)));
	var _args = string_split(_arg_string, ",");

	for (var _i = 0; _i < array_length(_args); _i++) {
		_args[_i] = string_trim(_args[_i]);
	}

	return {
		type: _type,
		args: _args
	};
}
/// @description Returns a struct containing the default state values for text rendering, including color, alpha, scale, font, and various effects.
/// @returns {struct} A struct with default text rendering state values.
function text_default_state() {
	return {
		color: c_white,
		alpha: 1,
		xscale: 1,
		yscale: 1,
		font: -1,

		wave: false,
		wobble: false,
		shake: false,
		bounce: false,
		rainbow: 0,
		rotate: 0,

        sine_amp: 0,
        sine_speed: 0,

        jitter: 0,
        sway: 0,
        spin: 0,

        zoom: 0,
        fade: 0,

        hsv: 0,
        flash: 0,

        offset_x: 0,
        offset_y: 0,

        line_height_mul: 1,
        space_add: 0
	};
}
/// @description Creates a copy of a given text state struct, allowing for modifications without affecting the original state.
/// @param {struct} _s The text state struct to clone.
/// @returns {struct} A new struct with the same values as the input state.
function text_clone_state(_s) {
	return {
		color: _s.color,
		alpha: _s.alpha,
		xscale: _s.xscale,
		yscale: _s.yscale,
		font: _s.font,

		wave: _s.wave,
		wobble: _s.wobble,
		shake: _s.shake,
		bounce: _s.bounce,
		rainbow: _s.rainbow,
		rotate: _s.rotate,

        sine_amp: _s.sine_amp,
        sine_speed: _s.sine_speed,

        jitter: _s.jitter,
        sway: _s.sway,
        spin: _s.spin,

        zoom: _s.zoom,
        fade: _s.fade,

        hsv: _s.hsv,
        flash: _s.flash,

        offset_x: _s.offset_x,
        offset_y: _s.offset_y,

        line_height_mul: _s.line_height_mul,
        space_add: _s.space_add
	};
}
/// @description Pushes a copy of the current text state onto a stack, allowing for nested state changes and easy restoration of previous states.
/// @param {array} _stack The stack to push the state onto.
/// @param {struct} _state The text state struct to push onto the stack.
function text_push_state(_stack, _state) {
	array_push(_stack, text_clone_state(_state));
}
/// @description Pops the last text state from a stack and returns it, allowing for restoration of previous states after temporary changes.
/// @param {array} _stack The stack to pop the state from.
/// @param {struct} _state The current text state struct, which will be replaced by the popped state.
/// @returns {struct} The new text state struct after popping from the stack
function text_pop_state(_stack, _state) {
	if (array_length(_stack) <= 0) return _state;

	var _last = array_length(_stack) - 1;
	var _new_state = _stack[_last];
	array_delete(_stack, _last, 1);

	return _new_state;
}
/// @description Applies a text tag token to the current text state, modifying the state based on the tag type and its arguments. This function handles various tags for color, scale, font, and effects.
/// @param {array} _stack The stack of text states for managing nested tags.
/// @param {struct} _state The current text state struct to be modified based on the tag token.
/// @param {struct} _token The tag token containing the type and arguments for the text modification.
/// @returns {struct} The modified text state struct after applying the tag token.
function text_apply_tag(_stack, _state, _token) {

	switch (_token.type) {

		case "CLOSE":
			_state = text_pop_state(_stack, _state);
		break;

		case "COLOR":
			text_push_state(_stack, _state);
			_state.color = text_color(_token.args[0]);

			if (array_length(_token.args) > 1) {
				_state.alpha = real(_token.args[1]);
			}
		break;

		case "SCALE":
			text_push_state(_stack, _state);

			var _s = real(_token.args[0]);
			_state.xscale = _s;
			_state.yscale = _s;
		break;

		case "XSCALE":
			text_push_state(_stack, _state);
			_state.xscale = real(_token.args[0]);
		break;

		case "YSCALE":
			text_push_state(_stack, _state);
			_state.yscale = real(_token.args[0]);
		break;

		case "FONT":
			text_push_state(_stack, _state);
			_state.font = text_asset(_token.args[0]);
		break;

		case "WAVE":
			text_push_state(_stack, _state);
			_state.wave = true;
		break;

		case "WOBBLE":
			text_push_state(_stack, _state);
			_state.wobble = true;
		break;

		case "SHAKE":
			text_push_state(_stack, _state);
			_state.shake = true;
		break;

		case "BOUNCE":
			text_push_state(_stack, _state);
			_state.bounce = true;
		break;

		case "RAINBOW":
			text_push_state(_stack, _state);
			_state.rainbow = 1;

			if (array_length(_token.args) > 0) {
				_state.rainbow = real(_token.args[0]);
			}
		break;

		case "ROTATE":
			text_push_state(_stack, _state);
			_state.rotate = real(_token.args[0]);
		break;

		case "RESET":
			_stack = [];
			_state = text_default_state();
		break;

        case "SPEED":
            REVEAL_SPEED = real(_token.args[0]);
        break;

        case "PAUSE":
            // handled externally (store pause timer if you want)
        break;

        case "SINE":
            text_push_state(_stack, _state);
            _state.sine_amp = real(_token.args[0]);
            _state.sine_speed = (array_length(_token.args) > 1) ? real(_token.args[1]) : 1;
        break;

        case "JITTER":
            text_push_state(_stack, _state);
            _state.jitter = real(_token.args[0]);
        break;

        case "SWAY":
            text_push_state(_stack, _state);
            _state.sway = real(_token.args[0]);
        break;

        case "SPIN":
            text_push_state(_stack, _state);
            _state.spin = real(_token.args[0]);
        break;

        case "ZOOM":
            text_push_state(_stack, _state);
            _state.zoom = real(_token.args[0]);
        break;

        case "FADE":
            text_push_state(_stack, _state);
            _state.fade = real(_token.args[0]);
        break;

        case "HSV":
            text_push_state(_stack, _state);
            _state.hsv = real(_token.args[0]);
        break;

        case "FLASH":
            text_push_state(_stack, _state);
            _state.flash = real(_token.args[0]);
        break;

        case "OFFSET":
            text_push_state(_stack, _state);
            _state.offset_x = real(_token.args[0]);
            _state.offset_y = real(_token.args[1]);
        break;

        case "LINEHEIGHT":
            text_push_state(_stack, _state);
            _state.line_height_mul = real(_token.args[0]);
        break;

        case "SPACE":
            text_push_state(_stack, _state);
            _state.space_add = real(_token.args[0]);
        break;
	}

	return _state;
}
/// @description Counts the number of visible characters in an array of text tokens, accounting for both text and sprite tokens. This is used for reveal effects to determine how many characters should be shown.
/// @param {array} _tokens The array of text tokens to count visible characters from.
/// @returns {real} The total count of visible characters represented by the tokens.
function text_visible_count(_tokens) {
	var _count = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == "TEXT") {
			_count += string_length(_token.value);
		}
		else if (_token.type == "SPRITE") {
			_count += 1;
		}
	}

	return _count;
}
/// @description Draws an array of text tokens to the screen at a specified position, with options for alignment, bounding box, and reveal effects. This function handles the rendering of both text and sprite tokens based on the current text state.
/// @param {array} _tokens The array of text tokens to draw.
/// @param {real} _x The x-coordinate for the starting position of the text.
/// @param {real} _y The y-coordinate for the starting position of the text.
/// @param {real} _halign The horizontal alignment for the text (fa_left, fa_center, fa_right).
/// @param {real} _valign The vertical alignment for the text (fa_top, fa_middle, fa_bottom).
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used.
/// @param {real} _box_h The height of the bounding box for the text. If -1, the height is determined by the text content.
/// @param {bool} _box_draw Whether to draw the bounding box behind the text.
/// @param {real} _reveal The number of characters to reveal for the text, used for typewriter effects. If 999999, all characters are revealed.
function text_draw_tokens(_tokens, _x, _y, _halign, _valign, _box_w, _box_h, _box_draw, _reveal) {

	var _state = text_default_state();
	var _stack = [];

	var _line_height = text_get_line_height(_tokens);
	var _total_width = text_measure_width_wrapped(_tokens, _box_w);
	var _total_height = text_measure_height_wrapped(_tokens, _box_w, _line_height);

	var _start_x = _x;
	var _start_y = _y;

	if (_halign == fa_center) _start_x -= _total_width * 0.5;
	if (_halign == fa_right)  _start_x -= _total_width;

	if (_valign == fa_middle) _start_y -= _total_height * 0.5;
	if (_valign == fa_bottom) _start_y -= _total_height;

	if (_box_draw && _box_w > 0) {
		draw_set_alpha(0.25);
		draw_set_color(c_white);
		draw_rectangle(_start_x, _start_y, _start_x + _box_w, _start_y + max(_box_h, _total_height), false);
		draw_set_alpha(1);
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _cursor_x = _start_x;
	var _cursor_y = _start_y;

	var _glyph_index = 0;
	var _visible_drawn = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
			}

			if (_box_w > 0 && _cursor_x + _spr_w > _start_x + _box_w) {
				_cursor_x = _start_x;
				_cursor_y += _line_height * _state.yscale;
			}

			if (_visible_drawn < _reveal && _spr != -1) {
				var _img = 0;
				var _spd = 0;

				if (array_length(_token.args) > 1) _img = real(_token.args[1]);
				if (array_length(_token.args) > 2) _spd = real(_token.args[2]);

				var _frame = _img;

				if (_spd != 0) {
					_frame = _img + current_time * 0.001 * _spd;
				}

				draw_sprite_ext(
					_spr,
					_frame,
					_cursor_x,
					_cursor_y,
					_state.xscale,
					_state.yscale,
					0,
					_state.color,
					_state.alpha
				);
			}

			_cursor_x += _spr_w;
			_visible_drawn++;
			_glyph_index++;
			continue;
		}

		var _txt = _token.value;
		var _word = "";

		for (var _c = 1; _c <= string_length(_txt); _c++) {
			var _char = string_char_at(_txt, _c);

			if (_char == "\n") {
				text_draw_word(_word, _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal);
				_cursor_x += string_width(_word) * _state.xscale;
				_visible_drawn += string_length(_word);
				_glyph_index += string_length(_word);

				_word = "";
				_cursor_x = _start_x;
				_cursor_y += _line_height * _state.yscale;
				continue;
			}

			if (_char == " ") {
				var _word_w = string_width(_word + " ") * _state.xscale;

				if (_box_w > 0 && _cursor_x + _word_w > _start_x + _box_w) {
					_cursor_x = _start_x;
					_cursor_y += _line_height * _state.yscale;
				}

				text_draw_word(_word + " ", _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal);

				_cursor_x += _word_w;
				_visible_drawn += string_length(_word + " ");
				_glyph_index += string_length(_word + " ");

				_word = "";
			}
			else {
				_word += _char;
			}
		}

		if (_word != "") {
			var _final_w = string_width(_word) * _state.xscale;

			if (_box_w > 0 && _cursor_x + _final_w > _start_x + _box_w) {
				_cursor_x = _start_x;
				_cursor_y += _line_height * _state.yscale;
			}

			text_draw_word(_word, _state, _cursor_x, _cursor_y, _glyph_index, _visible_drawn, _reveal);

			_cursor_x += _final_w;
			_visible_drawn += string_length(_word);
			_glyph_index += string_length(_word);
		}
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
}
/// @description Draws a single word to the screen with the specified text state and reveal effects. This function is called by text_draw_tokens to render each word based on the current state and how many characters should be revealed.
/// @param {string} _word The word to draw.
/// @param {struct} _state The current text state struct containing color, scale, font, and effects.
/// @param {real} _x The x-coordinate for the starting position of the word.
/// @param {real} _y The y-coordinate for the starting position of the word.
/// @param {real} _glyph_index The index of the first glyph of the word in the overall text, used for effects that depend on glyph position.
/// @param {real} _visible_drawn The number of characters that have already been drawn before this word, used for reveal effects.
/// @param {real} _reveal The total number of characters to reveal, used for typewriter effects. If 999999, all characters are revealed.
function text_draw_word(_word, _state, _x, _y, _glyph_index, _visible_drawn, _reveal) {
	if (_word == "") return;

	if (_state.font != -1) {
		draw_set_font(_state.font);
	}

	var _cursor_x = _x;

	for (var _i = 1; _i <= string_length(_word); _i++) {
		if (_visible_drawn >= _reveal) return;

		var _char = string_char_at(_word, _i);

		var _xx = _cursor_x;
		var _yy = _y;
		var _rot = _state.rotate;

        // WAVE
		if (_state.wave) {
			_yy += sin(current_time * 0.008 + _glyph_index * 0.45) * 4;
		}
        // WOBBLE
		if (_state.wobble) {
			_rot += sin(current_time * 0.01 + _glyph_index) * 8;
		}
        // SHAKE
		if (_state.shake) {
			_xx += random_range(-1.5, 1.5);
			_yy += random_range(-1.5, 1.5);
		}
        // BOUNCE
		if (_state.bounce) {
			_yy += abs(sin(current_time * 0.006 + _glyph_index * 0.35)) * -6;
		}

		var _draw_color = _state.color;

		if (_state.rainbow > 0) {
			var _h = frac(current_time * 0.0001 * _state.rainbow + _glyph_index * 0.035);
			_draw_color = make_color_hsv(_h * 255, 220, 255);
		}

        var t = current_time;

        _xx += _state.offset_x;
        _yy += _state.offset_y;

        // SINE
        if (_state.sine_amp != 0) {
            _yy += sin(t * 0.01 * _state.sine_speed + _glyph_index) * _state.sine_amp;
        }

        // SWAY
        if (_state.sway != 0) {
            _xx += sin(t * 0.01 + _glyph_index) * _state.sway;
        }

        // JITTER
        if (_state.jitter != 0) {
            _xx += random_range(-_state.jitter, _state.jitter);
            _yy += random_range(-_state.jitter, _state.jitter);
        }

        // SPIN
        _rot += _state.spin * t * 0.001;

        // ZOOM
        var _xs = _state.xscale;
        var _ys = _state.yscale;

        if (_state.zoom != 0) {
            var z = 1 + sin(t * 0.01 + _glyph_index) * _state.zoom;
            _xs *= z;
            _ys *= z;
        }

        // FADE
        var _alpha = _state.alpha;
        if (_state.fade != 0) {
            _alpha *= 0.5 + 0.5 * sin(t * 0.01 * _state.fade + _glyph_index);
        }

        // HSV
        var _draw_color = _state.color;
        if (_state.hsv != 0) {
            var h = frac(t * 0.0001 * _state.hsv + _glyph_index * 0.02);
            _draw_color = make_color_hsv(h * 255, 255, 255);
        }

        // FLASH
        if (_state.flash != 0) {
            if (sin(t * 0.02 * _state.flash) > 0) {
                _draw_color = c_white;
            }
        }

		draw_set_alpha(_alpha);
        draw_set_color(_draw_color);
        draw_text_transformed(_xx, _yy, _char, _xs, _ys, _rot);

		_cursor_x += string_width(_char) * _state.xscale;
		_visible_drawn++;
		_glyph_index++;
	}
}
/// @description Calculates the height of a line of text based on the tokens and any font or scale tags that may be present. This is used to determine line spacing when rendering wrapped text.
/// @param {array} _tokens The array of text tokens to analyze for line height.
/// @returns {real} The calculated line height for the text.
function text_get_line_height(_tokens) {
	var _height = string_height("A");
	var _state = text_default_state();
	var _stack = [];

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type == "FONT") {
			_state = text_apply_tag(_stack, _state, _token);

			if (_state.font != -1) {
				draw_set_font(_state.font);
				_height = max(_height, string_height("A"));
			}
		}

		if (_token.type == "SCALE" || _token.type == "YSCALE") {
			_state = text_apply_tag(_stack, _state, _token);
			_height = max(_height, string_height("A") * _state.yscale);
		}
	}

	return _height;
}
/// @description Measures the width of a block of text based on the tokens and any wrapping that may occur due to a specified box width. This is used to determine how wide the text will be when rendered with wrapping.
/// @param {array} _tokens The array of text tokens to analyze for width measurement.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and the width is simply the total width of the text.
/// @returns {real} The calculated width of the text block, accounting for wrapping if a box width is specified.
function text_measure_width_wrapped(_tokens, _box_w) {
	if (_box_w > 0) return _box_w;

	var _state = text_default_state();
	var _stack = [];

	var _width = 0;
	var _line_width = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "TEXT") {
			if (_state.font != -1) draw_set_font(_state.font);

			var _txt = _token.value;

			for (var _c = 1; _c <= string_length(_txt); _c++) {
				var _char = string_char_at(_txt, _c);

				if (_char == "\n") {
					_width = max(_width, _line_width);
					_line_width = 0;
				}
				else {
					_line_width += string_width(_char) * _state.xscale;
				}
			}
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);

			if (_spr != -1) {
				_line_width += sprite_get_width(_spr) * _state.xscale;
			}
		}
	}

	_width = max(_width, _line_width);
	return _width;
}
/// @description Measures the height of a block of text based on the tokens and any wrapping that may occur due to a specified box width. This is used to determine how tall the text will be when rendered with wrapping.
/// @param {array} _tokens The array of text tokens to analyze for height measurement.
/// @param {real} _box_w The width of the bounding box for the text. If -1, no bounding box is used and the height is simply the line height of the text.
/// @param {real} _line_height The height of a single line of text, used to calculate total height when wrapping occurs.
/// @returns {real} The calculated height of the text block, accounting for wrapping if a box width is specified.
function text_measure_height_wrapped(_tokens, _box_w, _line_height) {
	var _state = text_default_state();
	var _stack = [];

	var _lines = 1;
	var _line_width = 0;

	for (var _i = 0; _i < array_length(_tokens); _i++) {
		var _token = _tokens[_i];

		if (_token.type != "TEXT" && _token.type != "SPRITE") {
			_state = text_apply_tag(_stack, _state, _token);
			continue;
		}

		if (_token.type == "SPRITE") {
			var _spr = text_asset(_token.args[0]);
			var _spr_w = 0;

			if (_spr != -1) {
				_spr_w = sprite_get_width(_spr) * _state.xscale;
			}

			if (_box_w > 0 && _line_width + _spr_w > _box_w) {
				_lines++;
				_line_width = 0;
			}

			_line_width += _spr_w;
		}

		if (_token.type == "TEXT") {
			if (_state.font != -1) draw_set_font(_state.font);

			var _txt = _token.value;
			var _word = "";

			for (var _c = 1; _c <= string_length(_txt); _c++) {
				var _char = string_char_at(_txt, _c);

				if (_char == "\n") {
					_lines++;
					_line_width = 0;
					_word = "";
					continue;
				}

				if (_char == " ") {
					var _word_w = string_width(_word + " ") * _state.xscale;

					if (_box_w > 0 && _line_width + _word_w > _box_w) {
						_lines++;
						_line_width = 0;
					}

					_line_width += _word_w;
					_word = "";
				}
				else {
					_word += _char;
				}
			}

			if (_word != "") {
				var _final_w = string_width(_word) * _state.xscale;

				if (_box_w > 0 && _line_width + _final_w > _box_w) {
					_lines++;
					_line_width = 0;
				}

				_line_width += _final_w;
			}
		}
	}

	return _lines * _line_height;
}
/// @description Converts a string representing an asset name into the corresponding asset index. If the string can be converted to a real number, it returns that number instead, allowing for direct numeric asset references.
/// @param {string} _name The string representing the asset name or numeric index to convert.
/// @returns {real} The asset index corresponding to the input string, either from a named asset or directly from a real number conversion.
function text_is_numeric_string(_value) {
	_value = string_trim(string(_value));

	var _len = string_length(_value);
	if (_len <= 0) {
		return false;
	}

	var _has_digit = false;
	var _has_decimal = false;

	for (var _i = 1; _i <= _len; _i++) {
		var _char = string_char_at(_value, _i);

		if ((_char == "+" || _char == "-") && _i == 1) {
			continue;
		}

		if (_char == "." && !_has_decimal) {
			_has_decimal = true;
			continue;
		}

		if (_char >= "0" && _char <= "9") {
			_has_digit = true;
			continue;
		}

		return false;
	}

	return _has_digit;
}

function text_asset(_name) {
	_name = string_trim(string(_name));

	if (text_is_numeric_string(_name)) {
		return real(_name);
	}

	return asset_get_index(_name);
}
/// @description Converts a string representing a color name into the corresponding color value. This function supports a predefined set of color names (e.g., "c_red", "c_blue") and returns the associated color constant. If the string does not match any known color name, it attempts to convert it to a real number, allowing for direct color values to be used as well.
/// @param {string} _name The string representing the color name or value to convert.
/// @returns {real} The color value corresponding to the input string, either from a predefined color name or directly from a real number conversion.
function text_color(_name) {
	_name = string_lower(string_trim(string(_name)));

	switch (_name) {
		case "c_white": return c_white;
		case "c_black": return c_black;
		case "c_red": return c_red;
		case "c_green": return c_green;
		case "c_blue": return c_blue;
		case "c_yellow": return c_yellow;
		case "c_orange": return c_orange;
		case "c_purple": return c_purple;
		case "c_aqua": return c_aqua;
		case "c_fuchsia": return c_fuchsia;
		case "c_lime": return c_lime;
		case "c_gray": return c_gray;
		case "c_grey": return c_gray;
		case "c_silver": return c_silver;
		case "c_maroon": return c_maroon;
		case "c_navy": return c_navy;
	}

	if (text_is_numeric_string(_name)) {
		return real(_name);
	}

	return c_white;
}

/// @description Creates a text renderer object that can be drawn to the screen with various options for alignment, bounding box, and reveal effects.
/// @param {string} _string The string to be rendered by the text object.
function TextRenderer(_string) constructor {

	/*===================================================*
	* VARIABLES
	*===================================================*/
	STRING = _string;
	TOKENS = text_parse(_string);

	HALIGN = fa_left;
	VALIGN = fa_top;

	BOX_W = -1;
	BOX_H = -1;
	BOX_DRAW = false;

	REVEAL = 999999;
	REVEAL_SPEED = 1;

	/*===================================================*
	* METHODS
	*===================================================*/

	draw = function(_x, _y) {
		text_draw_tokens(TOKENS, _x, _y, HALIGN, VALIGN, BOX_W, BOX_H, BOX_DRAW, REVEAL);
		return self;
	}

	setHALIGN = function(_h) {
		HALIGN = _h;
		return self;
	}

	setVALIGN = function(_v) {
		VALIGN = _v;
		return self;
	}

	setBOX = function(_w, _h = -1) {
		BOX_W = _w;
		BOX_H = _h;
		return self;
	}

	setBOX_DRAW = function(_draw) {
		BOX_DRAW = _draw;
		return self;
	}

	setREVEAL = function(_chars) {
		REVEAL = _chars;
		return self;
	}

	stepREVEAL = function(_speed = 1) {
		REVEAL += _speed;
		return self;
	}

	resetREVEAL = function() {
		REVEAL = 0;
		return self;
	}

	isFINISHED = function() {
		return REVEAL >= text_visible_count(TOKENS);
	}
}

/// @description Convenience wrapper for creating a text renderer without calling the constructor directly.
/// @param {string} _string The string to be rendered by the text object.
/// @returns {TextRenderer}
function text(_string) {
	return new TextRenderer(_string);
}
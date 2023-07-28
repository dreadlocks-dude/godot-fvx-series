shader_type spatial;

uniform float distortion_amount: hint_range(-0.25, 0.75) = 0.1;
uniform float distortion_speed = 1.0;
uniform int ribs_count = 8;
uniform int twist_loops = 10;
uniform float rotation_speed = 1.0;

vec3 animate_vector(vec3 value, float animation_speed) {
	return cos(TAU * (value + TIME * animation_speed));
}

float animate(float value, float animation_speed) {
	return cos(TAU * (value + TIME * animation_speed));
}

float scale_to_unit(float cos_value) {
	return cos_value * 0.5 + 0.5;
}

vec3 scale_to_unit_vector(vec3 cos_value) {
	return cos_value * 0.5 + 0.5;
}

float get_twist_phase(vec2 uv) {
	return float(ribs_count) * uv.y      // Creating ribs along Y axes
			+ uv.x * float(twist_loops); // twist it along X axes
}

float twist_height(vec2 uv) {
	return scale_to_unit(animate(get_twist_phase(uv), rotation_speed));
}

vec3 saturate_colors(vec3 color) {
	return pow(color, vec3(2.2));
}

vec3 get_rainbow(vec2 uv) {
	float phase = get_twist_phase(uv) / float(ribs_count);
	vec3 rainbow = phase + vec3(0.0, 0.333, 0.666);
	vec3 color = saturate_colors(
				scale_to_unit_vector(
					animate_vector(rainbow, rotation_speed)
				));
	return color * (scale_to_unit(animate(uv.y, rotation_speed)) * 4.0 + 2.0);
}

float get_distortion(vec2 uv) {
	return twist_height(uv) 
	* scale_to_unit(animate(0.0, distortion_speed))
	* distortion_amount;
}

void vertex() {
	VERTEX += NORMAL * get_distortion(UV);
}

void fragment() {
	ALBEDO = get_rainbow(UV);
	
	ROUGHNESS = 0.1;
	METALLIC = 0.1;
	
	// Dynamic normal calculation
	const vec2 eps = vec2(0.02, 0.0);
	NORMAL_MAP = scale_to_unit_vector(normalize(vec3(
		get_distortion(UV - eps) - get_distortion(UV + eps),
	    get_distortion(UV + eps.yx) - get_distortion(UV - eps.yx),
		eps.x * 2.0
		)));
		
	
}

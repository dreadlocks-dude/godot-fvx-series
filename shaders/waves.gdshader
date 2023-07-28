shader_type spatial;
render_mode cull_disabled;

uniform vec4 albedo: source_color;
uniform float frequency = 20.0;
uniform float amplitude = 0.1;
uniform float metallic = 0.5;
uniform float roughness = 0.5;

void vertex() {
	float distance_from_center = length(UV - 0.5) * 2.0;
	float height = cos(distance_from_center * PI * frequency);
	VERTEX += NORMAL * amplitude * height;
}

void fragment() {
//	ALBEDO = texture(pattern, UV * 2.0).rgb * albedo.rgb;
//	if (UV.x > UV.y) discard; // Slice in half
	ALBEDO = albedo.rgb;
//	ROUGHNESS = roughness;
//	METALLIC = metallic;
}

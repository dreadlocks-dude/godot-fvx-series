shader_type spatial;

uniform sampler2D normal_map: hint_normal;
uniform sampler2D albedo_tex: hint_default_white;
uniform vec4 albedo: source_color;

void fragment() {
	float distance_to_corner = UV.x / (0.9 * UV.y + 0.1);
	float phase = cos(distance_to_corner * PI * 5.0);
	float waves = smoothstep(0.6, 0.7, abs(phase));
	NORMAL_MAP = texture(normal_map, UV * 2.0).xyz;
	ALBEDO = albedo.rgb * texture(albedo_tex, UV * 2.0).rgb;
    METALLIC = waves * 0.7;
	ROUGHNESS = 1.0 - METALLIC;
}

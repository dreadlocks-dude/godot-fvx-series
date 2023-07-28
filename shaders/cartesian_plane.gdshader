shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture: hint_default_white, filter_linear_mipmap_anisotropic;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_linear_mipmap;



void fragment() {
	vec4 color = texture(albedo_texture, UV);
	float f = textureLod(depth_texture, SCREEN_UV, 2.0).r;
	vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, f, 1.0);
    float delta = abs(upos.z / upos.w - VERTEX.z);
	float curve = smoothstep(0.023, 0.0, delta);
	ALBEDO = mix(vec3(0.0), vec3(12.0, 2.0, 2.0), curve);
	ALPHA = max(1.0 - pow(color.r, 8.0) * 0.9, pow(smoothstep(0.9, 0.03, delta), 10.0));
}

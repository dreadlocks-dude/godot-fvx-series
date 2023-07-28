shader_type spatial;
// No default shading
render_mode unshaded;
// Render back side of the cylinder
render_mode cull_disabled;
// Make object appear as pure light or "hologram"
render_mode blend_add;

												  // Default to cyan
uniform vec4  albedo:       source_color          = vec4(0.0, 1.0, 1.0, 1.0); 
uniform float brightness:   hint_range(0.0, 10.0) = 2.0;

uniform float bottom_width: hint_range(0.0, 1.0)  = 0.2;
uniform float portal_curve: hint_range(0.0, 20.0) = 10.0;

uniform float top_fade:     hint_range(0.0, 5.0)  = 0.5;
uniform float bottom_fade:  hint_range(0.0, 5.0)  = 0.2;
uniform float central_fade: hint_range(0.0, 10.0) = 2.0;

uniform float horizontal_lines = 10.0;
uniform float horizontal_lines_width: hint_range(0.001, 10.0) = 1.0;

uniform float vertical_lines = 10.0;
uniform float vertical_lines_strength: hint_range(0.0, 1.0) = 0.5;
uniform float vertical_lines_width:	  hint_range(0.001, 10.0) = 1.0;

uniform float line_noise: hint_range(0.0, 0.5) = 0.3;
uniform float speed = 20.0;

float draw_lines(float height, float num_lines, float width) {
	float phase = (height * num_lines + TIME * speed) * TAU;
	float line = cos(phase) * 0.5 + 0.5;
	// A little twist here, to make our effect more "realistic"
	// Try with and without it, see components A and B separately
	line *= mix(1.0, cos(phase * 0.75), line_noise);
	line = pow(line, 1.0 / width);
	return line;
}

void vertex() {
	VERTEX += NORMAL * pow(UV.y * 2.0, portal_curve) * bottom_width;
}

void fragment() {
	float height = UV.y * 2.0;
	
	ALPHA = albedo.a;
	if (vertical_lines > 0.01 && vertical_lines_width > 0.001) {
		ALPHA *= mix(1.0, 
				    draw_lines(UV.x, vertical_lines, vertical_lines_width) 
					,vertical_lines_strength); 
	}
	if (horizontal_lines > 0.01 && horizontal_lines_width > 0.001) {
		ALPHA *= draw_lines(height, horizontal_lines, horizontal_lines_width);
	}
	ALPHA *= smoothstep(0.0, top_fade, height);
	ALPHA *= smoothstep(0.0, bottom_fade, 1.0 - height);
	ALPHA *= pow(1.0 - abs(dot(VIEW, NORMAL)), central_fade);
	ALPHA *= brightness;
	ALBEDO = albedo.rgb;
}

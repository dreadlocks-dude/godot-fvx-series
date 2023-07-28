shader_type spatial;
render_mode unshaded;      // No default shading
render_mode blend_add;     // Mix dark areas as well as bright ones
render_mode cull_back; // Show back side of the orb

// Make color selectable in UI
uniform vec4  orb_color:   source_color;                 

// Make curvature selectable in UI with a slider, equal to 3 by default.
uniform float curve_power: hint_range(0.01, 10.0) = 3.0;
uniform bool animate = false;
uniform float animation_cycle_duration = 3.0;

// We custom function to wrap around out formula, we can re-use it later
float curve(float x) {
	float n = curve_power;
	if (animate) {
		n = cos(TIME * TAU / animation_cycle_duration) * 2.5 + 2.51;
	}
	// Our "magic formula" - just a simple <X> to the power of <curve_power>
	return pow(x, n);
}

// Built-in function name, without it nothing gets drawn
void fragment() {
   // Dot product = cosine of the angle between vectors
   // One of the most useful shader tricks, used literally everywhere    
   // It tells us where the pixel "looks at"
   // 1.0 == "looks straight at us"
   // 0.0 == "looks" to the side (left, right, up, anywhere on the rim)
   // -1.0 == It looks away from camera view
   float VdotN = dot(VIEW, NORMAL); 
   
   // Makes orb transparent in the middle, and "thick" at the rim 
   float view_angle = 1.0 - abs(VdotN); 

   // Now we apply curve to the original color
   // We calculate "how much of the color to retain"
   // When curve() gives us low number - orb is transparent
   // Hight number - orb is visible
   vec4 new_color = orb_color * curve(view_angle); 
   
   // We apply new color, only RGB component. 
   // There is also new_color.a - ALPHA (transparency) component
   // But it just looks cooler not to use it :) You can experiment and see
   ALBEDO = new_color.rgb;
   
   // Use original transparency that user picked in the UI
   // If we don't put ALPHA value, orb won't be transparent at all
   ALPHA = orb_color.a;
}
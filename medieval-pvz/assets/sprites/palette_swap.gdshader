shader_type canvas_item;

uniform vec4 source_color_0 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_0 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_3 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_3 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_4 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_4 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_5 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_5 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_6 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_6 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_7 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_7 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 source_color_8 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 target_color_8 : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform bool enabled_0 = false;
uniform bool enabled_1 = false;
uniform bool enabled_2 = false;
uniform bool enabled_3 = false;
uniform bool enabled_4 = false;
uniform bool enabled_5 = false;
uniform bool enabled_6 = false;
uniform bool enabled_7 = false;
uniform bool enabled_8 = false;

uniform float match_threshold: hint_range(0.0, 0.2) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec3 rgb = tex_color.rgb;
	float alpha = tex_color.a;

	if (alpha > 0.0 && enabled_0 && distance(rgb, source_color_0.rgb) <= match_threshold) {
		rgb = target_color_0.rgb;
	} else if (alpha > 0.0 && enabled_1 && distance(rgb, source_color_1.rgb) <= match_threshold) {
		rgb = target_color_1.rgb;
	} else if (alpha > 0.0 && enabled_2 && distance(rgb, source_color_2.rgb) <= match_threshold) {
		rgb = target_color_2.rgb;
	} else if (alpha > 0.0 && enabled_3 && distance(rgb, source_color_3.rgb) <= match_threshold) {
		rgb = target_color_3.rgb;
	} else if (alpha > 0.0 && enabled_4 && distance(rgb, source_color_4.rgb) <= match_threshold) {
		rgb = target_color_4.rgb;
	} else if (alpha > 0.0 && enabled_5 && distance(rgb, source_color_5.rgb) <= match_threshold) {
		rgb = target_color_5.rgb;
	} else if (alpha > 0.0 && enabled_6 && distance(rgb, source_color_6.rgb) <= match_threshold) {
		rgb = target_color_6.rgb;
	} else if (alpha > 0.0 && enabled_7 && distance(rgb, source_color_7.rgb) <= match_threshold) {
		rgb = target_color_7.rgb;
	} else if (alpha > 0.0 && enabled_8 && distance(rgb, source_color_8.rgb) <= match_threshold) {
		rgb = target_color_8.rgb;
	}

	COLOR = vec4(rgb, alpha);
}
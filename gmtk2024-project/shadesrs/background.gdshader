shader_type canvas_item;

uniform sampler2D noise_texture: repeat_enable, filter_nearest;

void fragment() {
	float noise = texture(noise_texture, UV).r;
	
	COLOR.a *= round(noise);
}


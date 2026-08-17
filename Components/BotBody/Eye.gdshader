shader_type canvas_item;


// ================================
// Spherize UV
// ================================

vec2 spherize_uv(
	vec2 uv,
	vec2 center,
	float strength,
	vec2 offset
) {
	vec2 delta = uv - center;

	float delta2 = dot(delta, delta);
	float delta4 = delta2 * delta2;

	return uv
		+ delta * delta4 * strength
		+ offset;
}


// ================================
// SDF
// ================================

float circle_sdf(vec2 p, vec2 c, float r) {
	return length(p - c) - r;
}


float smin(float a, float b, float k) {
	float h = clamp(
		0.5 + 0.5 * (b - a) / k,
		0.0,
		1.0
	);

	return mix(b, a, h)
		- k * h * (1.0 - h);
}


// ================================
// 兩顆球
// 0,0 = 中央
// ================================

uniform vec2 pos_a = vec2(0.0, 0.0);
uniform vec2 pos_b = vec2(0.0, 0.0);

uniform float radius_a
	: hint_range(0.01, 0.5, 0.01)
	= 0.15;

uniform float radius_b
	: hint_range(0.01, 0.5, 0.01)
	= 0.15;

uniform float smoothness
	: hint_range(0.001, 0.5, 0.001)
	= 0.12;


// ================================
// 整體 UV Spherize
// ================================

uniform vec2 pup_offset = vec2(0.0, 0.0);

uniform float spherize_strength
	: hint_range(-20.0, 20.0, 0.01)
	= 4.0;


// ================================
// 少量視線飄移
// ================================

uniform float drift_amount
	: hint_range(0.0, 0.1, 0.001)
	= 0.008;

uniform float drift_speed = 1.2;


// ================================
// 整體縮放呼吸
// ================================

uniform float breathe_amount
	: hint_range(0.0, 0.2, 0.001)
	= 0.03;

uniform float breathe_speed = 1.6;


void fragment() {

	// UV:
	// 0.5,0.5 -> 0,0
	vec2 uv = UV - vec2(0.5);


	// =================================
	// 少量視線飄移
	// 讓整體位置有很小的漂移
	// =================================

	float t = TIME * drift_speed;

	vec2 drift = vec2(
		sin(t * 1.13) + sin(t * 2.07) * 0.35,
		cos(t * 0.91) + sin(t * 1.61) * 0.35
	) * drift_amount;


	vec2 final_pos_a = pos_a + drift;
	vec2 final_pos_b = pos_b + drift;


	// =================================
	// 整體 UV 先做 Spherize
	// =================================

	vec2 warped_uv = spherize_uv(
		uv,
		pup_offset,
		spherize_strength,
		vec2(0.0)
	);


	// =================================
	// 整體縮放呼吸
	// 對整體座標空間縮放，不是只改球半徑
	// =================================

	float breathe = 1.0 + sin(TIME * breathe_speed) * breathe_amount;

	vec2 final_uv = warped_uv / breathe;


	// =================================
	// 然後才生成兩顆球
	// =================================

	float a = circle_sdf(
		final_uv,
		final_pos_a,
		radius_a
	);

	float b = circle_sdf(
		final_uv,
		final_pos_b,
		radius_b
	);


	// 兩顆球融合
	float c = smin(
		a,
		b,
		smoothness
	);


	// 透明背景
	float alpha =
		1.0 - smoothstep(
			0.0,
			0.01,
			c
		);


	COLOR = vec4(
		vec3(1.0),
		alpha
	);
}
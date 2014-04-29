precision highp float;

uniform sampler2D texture;
uniform float redValue;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

vec3 rgb2hsv(vec3 c);
vec3 hsv2rgb(vec3 c);

void main()


{
    vec3 color = vec3(texture2D(texture, tex_coord_frag.st));
    vec3 LumCoeff = vec3(0.2155, 0.7154, 0.0721);
    
    vec3 AvgLumin = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(color, LumCoeff));
    
    vec3 satColor = mix(intensity, color, 1.0);
    vec3 conColor = mix(AvgLumin, satColor, redValue + 0.5);
    
    gl_FragColor = color_frag * vec4(conColor, 1.0);
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
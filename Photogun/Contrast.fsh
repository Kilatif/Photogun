#define RED_COLOR_TYPE      0
#define GREEN_COLOR_TYPE    1
#define BLUE_COLOR_TYPE     2

#define BRIGHTNESS_FILTER_TYPE          0
#define CONTRAST_FILTER_TYPE            1

#define EXPOSITION_FILTER_TYPE          2
#define GAMMA_CORRECTION_FILTER_TYPE    3

#define BALANCE_SHADOWS_FILTER_TYPE      4
#define BALANCE_MIDTONES_FILTER_TYPE     7
#define BALANCE_LIGHTS_FILTER_TYPE      10

#define BLUR_FILTER_TYPE                13

#define VIGNETTE_OUTER_FILTER_TYPE      14
#define VIGNETTE_INTER_FILTER_TYPE      15
#define VIGNETTE_INTENSITY_FILTER_TYPE  16

precision highp float;

uniform sampler2D texture;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

varying vec2 coefs_R;
varying vec2 coefs_G;
varying vec2 coefs_B;

uniform float filters_values[17];
uniform int filters_order[17];

const float blurH = 1.0 / 480.0;
const float blurW = 1.0 / 640.0;

#pragma mark - interface

vec3 rgb2hsv(vec3 c);
vec3 hsv2rgb(vec3 c);

float valueWithCoef(float value, vec2 coef);
vec4 horisontalBlur(int coef);
vec4 vignette(vec4 oldColor, float outerRadius, float interRadius, float intensity);

#pragma mark - implementation

void main()
{
    gl_FragColor = color_frag * vignette(horisontalBlur(int(filters_values[BLUR_FILTER_TYPE])),
                                         filters_values[VIGNETTE_OUTER_FILTER_TYPE],
                                         filters_values[VIGNETTE_INTER_FILTER_TYPE],
                                         filters_values[VIGNETTE_INTENSITY_FILTER_TYPE]);
}

float valueWithCoef(float value, vec2 coef)
{
    return coef.x + coef.y * value;
}

vec4 texture2Dfiltered(sampler2D textureSampler, vec2 coord)
{
    vec4 color = texture2D(textureSampler, coord);
    
    color = vec4(valueWithCoef(color.r, coefs_R),
                 valueWithCoef(color.g, coefs_G),
                 valueWithCoef(color.b, coefs_B), 1.0);
    
    return color;
}

//coef = 1.0 - minimal 10.0 - maximum
vec4 horisontalBlur(int coef)
{
    coef = int(max(float(coef), 1.0));
    coef = int(min(float(coef), 10.0));
    
    float a = 1.0;
    float d = (100.0 - a * (2.0*float(coef) + 1.0)) / float(coef * coef);
    
    vec4 sum = vec4(0.0);
    
    for (int i = 0; i < coef; i++)
    {
        float offset_l = float(coef - i) * blurW;
        float persent_l = (float(i) * d + a) / 100.0;
        
        float offset_r = float(i + 1) * blurW;
        float persent_r = (float(coef - i - 1) * d + a) / 100.0;
        
        sum += texture2Dfiltered(texture, vec2(tex_coord_frag.x, tex_coord_frag.y - offset_l)) * persent_l;
        sum += texture2Dfiltered(texture, vec2(tex_coord_frag.x, tex_coord_frag.y + offset_r)) * persent_r;
    }
    
    float persent = (float(coef) * d + a) / 100.0;
    sum += texture2Dfiltered(texture, vec2(tex_coord_frag.x, tex_coord_frag.y)) * persent;
    
    return sum;
}

vec4 vignette(vec4 oldColor, float outerRadius, float interRadius, float intensity)
{
    if (interRadius >= outerRadius)
        interRadius = outerRadius - 0.01;
    
    vec2 u_resolution = vec2(330, 400);
    
    vec2 relativePosition = gl_FragCoord.xy / u_resolution - 0.5;
    float len = length(relativePosition);
    float vignette = smoothstep(outerRadius, interRadius, len);
    oldColor.rgb = mix(oldColor.rgb, oldColor.rgb * vignette, intensity);
    
    return oldColor;
}
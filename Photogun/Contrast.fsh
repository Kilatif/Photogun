#define RED_COLOR_TYPE      0
#define GREEN_COLOR_TYPE    1
#define BLUE_COLOR_TYPE     2

#define CONTRAST_FILTER_TYPE            0
#define SATURATION_FILTER_TYPE          1
#define BRIGHTNESS_FILTER_TYPE          2

#define EXPOSITION_FILTER_TYPE          3
#define GAMMA_CORRECTION_FILTER_TYPE    4

#define BALANCE_MIDTONES_FILTER_TYPE    5
#define BALANCE_SHADOWS_FILTER_TYPE     8
#define BALANCE_LIGHTS_FILTER_TYPE      11

#define BLUR_FILTER_TYPE                14

precision highp float;

uniform sampler2D texture;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

//uniform boo0l filtersEnabled[15];
uniform float filters_values[15];
uniform int filters_order[15];

uniform float filter_value;
uniform int filter_id;

#pragma mark - interface

vec3 rgb2hsv(vec3 c);
vec3 hsv2rgb(vec3 c);

vec3 contrast(vec3 oldColor, float contrastValue);
vec3 saturation(vec3 oldColor, float saturationValue);
vec3 brightness(vec3 oldColor, float brightnessValue);

vec3 exposition(vec3 oldColor, float expositionValue);
vec3 gammaCorrection(vec3 oldColor, float correctionValue);

vec3 colorBalanceMidtonesOne(vec3 oldColor, float value, int colorType);
vec3 colorBalanceShadowsOne(vec3 oldColor, float value, int colorType);
vec3 colorBalanceLightOne(vec3 oldColor, float value, int colorType);

vec4 colorControl(vec4 oldColor);
vec4 activateFilter(int filterType, vec4 oldColor, float value);

#pragma mark - implementation

void main()
{
    vec4 color = texture2D(texture, tex_coord_frag.st);

    color = colorControl(color);
    //color = activateFilter(filter_id, color, filter_value);
    
    gl_FragColor = color_frag * color;
}

vec4 colorControl(vec4 oldColor)
{
    vec4 color = oldColor;
    for (int i = 0; i < 15; i++)
    {
        if (filters_order[i] >= 0)
        {
            int filterType = filters_order[i];
            color = activateFilter(filterType, color, filters_values[filterType]);
        }
    }
    
    
    return color;
}

vec4 activateFilter(int filterType, vec4 oldColor, float value)
{
    vec3 result;
    
    
    if (filterType == CONTRAST_FILTER_TYPE)
        result = contrast(oldColor.rgb, value);
    
    else if (filterType == SATURATION_FILTER_TYPE)
        result = saturation(oldColor.rgb, value);
    
    else if (filterType == BRIGHTNESS_FILTER_TYPE)
        result = brightness(oldColor.rgb, value);
    
    else if (filterType == EXPOSITION_FILTER_TYPE)
        result = exposition(oldColor.rgb, value);
    
    else if (filterType == GAMMA_CORRECTION_FILTER_TYPE)
        result = gammaCorrection(oldColor.rgb, value);
    
    else if (filterType == BALANCE_MIDTONES_FILTER_TYPE + RED_COLOR_TYPE)
        result = colorBalanceMidtonesOne(oldColor.rgb, value, RED_COLOR_TYPE);
        
    else if (filterType == BALANCE_MIDTONES_FILTER_TYPE + GREEN_COLOR_TYPE)
        result = colorBalanceMidtonesOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
        
    else if (filterType == BALANCE_MIDTONES_FILTER_TYPE + BLUE_COLOR_TYPE)
        result = colorBalanceMidtonesOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
    else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + RED_COLOR_TYPE)
        result = colorBalanceShadowsOne(oldColor.rgb, value, RED_COLOR_TYPE);
    
    else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + GREEN_COLOR_TYPE)
        result = colorBalanceShadowsOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
    
    else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + BLUE_COLOR_TYPE)
        result = colorBalanceShadowsOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
    else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + RED_COLOR_TYPE)
        result = colorBalanceLightOne(oldColor.rgb, value, RED_COLOR_TYPE);
    
    else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + GREEN_COLOR_TYPE)
        result = colorBalanceLightOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
    
    else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + BLUE_COLOR_TYPE)
        result = colorBalanceLightOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
    return vec4(result, 1.0);
}

#pragma mark - BCS filters (Brightness, Contrast, Saturation)

//brightnessValue = 0.0 - minimal, 2.0 = maximum
vec3 brightness(vec3 oldColor, float brightnessValue)
{
    brightnessValue = max(brightnessValue, 0.0);
    brightnessValue = min(brightnessValue, 2.0);
    
    vec3 avgLumin;
    
    if (brightnessValue < 1.0)
    {
        brightnessValue = 2.0 - brightnessValue;
        avgLumin = vec3(1.0, 1.0, 1.0);
    }
    else
        avgLumin = vec3(0.0, 0.0, 0.0);
    
    return mix(avgLumin, oldColor.rgb, brightnessValue);
}

//contrastValue = 0.5 - minimal, 2.5 = maximum
vec3 contrast(vec3 oldColor, float contrastValue)
{
    contrastValue = max(contrastValue, 0.5);
    contrastValue = min(contrastValue, 2.5);
    
    vec3 avgLumin = vec3(0.5, 0.5, 0.5);

    return mix(avgLumin, oldColor.rgb, contrastValue);
}

//saturationValue = 0.0 - minimal, 2.0 - maximum
vec3 saturation(vec3 oldColor, float saturationValue)
{
    saturationValue = max(saturationValue, 0.0);
    saturationValue = min(saturationValue, 2.0);
    
    vec3 lumCoeff = vec3(0.2155, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(oldColor, lumCoeff));
    
    return mix(intensity, oldColor, saturationValue);
}

#pragma mark - Exposition and Gamma-Correction

//expositionValue = 0.5 - minimal, 1.5 - maximal
vec3 exposition(vec3 oldColor, float expositionValue)
{
    expositionValue = max(expositionValue, 0.5);
    expositionValue = min(expositionValue, 1.5);
    
    vec3 interpolColor = vec3(0.0, 0.0, 0.0);
    
    return mix(interpolColor, oldColor, expositionValue);
}

//expositionValue = 0.5 - minimal, 1.5 - maximal
vec3 gammaCorrection(vec3 oldColor, float correctionValue)
{
    correctionValue = max(correctionValue, 0.5);
    correctionValue = min(correctionValue, 1.5);
    
    vec3 interpolColor = vec3(1.0, 1.0, 1.0);
    
    return mix(interpolColor, oldColor, correctionValue);
}

#pragma mark - Color balance filters

//value = 0.5 - minimal, 1.5 - maximum
vec3 colorBalanceMidtonesOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.5);
    value = min(value, 1.5);
    
    vec3 interpolColor = vec3(oldColor.r, oldColor.g, oldColor.b);
    
    if (colorType == RED_COLOR_TYPE)
        interpolColor = vec3(1.0, oldColor.g, oldColor.b);
    
    if (colorType == GREEN_COLOR_TYPE)
        interpolColor = vec3(oldColor.r, 1.0, oldColor.b);
    
    if (colorType == BLUE_COLOR_TYPE)
        interpolColor = vec3(oldColor.r, oldColor.g, 1.0);
    
    vec3 result = mix(interpolColor, oldColor, 2.0 - value);
    
    if (colorType == RED_COLOR_TYPE)
        interpolColor = vec3(result.r, 1.0, 1.0);
    
    if (colorType == GREEN_COLOR_TYPE)
        interpolColor = vec3(1.0, result.g, 1.0);
    
    if (colorType == BLUE_COLOR_TYPE)
        interpolColor = vec3(1.0, 1.0, result.b);
    
    result = mix(interpolColor, result, value);
    
    return result;
}

//value = 0.5 - minimal, 1.5 - maximum
vec3 colorBalanceShadowsOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.0);
    value = min(value, 2.0);
    
    vec3 interpolColor;
    
    if (value < 1.0)
    {
        value = 2.0 - value;
        if (colorType == RED_COLOR_TYPE)
            interpolColor = vec3(1.0, oldColor.g, oldColor.b);
        
        if (colorType == GREEN_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, 1.0, oldColor.b);
        
        if (colorType == BLUE_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, oldColor.g, 1.0);
    }
    else
    {
        if (colorType == RED_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, 1.0, 1.0);
        
        if (colorType == GREEN_COLOR_TYPE)
            interpolColor = vec3(1.0, oldColor.g, 1.0);
        
        if (colorType == BLUE_COLOR_TYPE)
            interpolColor = vec3(1.0, 1.0, oldColor.b);
    }
    
    vec3 result = mix(interpolColor, oldColor, value);
    
    return result;
}

//value = 0.0 - minimal, 2.0 - maximum
vec3 colorBalanceLightOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.0);
    value = min(value, 2.0);
    
    vec3 interpolColor;
    
    if (value > 1.0)
    {
        if (colorType == RED_COLOR_TYPE)
            interpolColor = vec3(0.0, oldColor.g, oldColor.b);
        
        if (colorType == GREEN_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, 0.0, oldColor.b);
        
        if (colorType == BLUE_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, oldColor.g, 0.0);
    }
    else
    {
        value = 2.0 - value;
        if (colorType == RED_COLOR_TYPE)
            interpolColor = vec3(oldColor.r, 0.0, 0.0);
        
        if (colorType == GREEN_COLOR_TYPE)
            interpolColor = vec3(0.0, oldColor.g, 0.0);
        
        if (colorType == BLUE_COLOR_TYPE)
            interpolColor = vec3(0.0, 0.0, oldColor.b);
    }
    
    vec3 result = mix(interpolColor, oldColor, value);
    
    return result;
}

#pragma mark - Convert functions

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
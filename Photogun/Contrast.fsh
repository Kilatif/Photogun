#define RED_COLOR_TYPE 1
#define GREEN_COLOR_TYPE 2
#define BLUE_COLOR_TYPE 3

precision highp float;

uniform sampler2D texture;
uniform float redValue;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

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

#pragma mark - implementation

void main()
{
    vec3 color = vec3(texture2D(texture, tex_coord_frag.st));
    
    vec3 conColor = colorBalanceLightOne(color, redValue, GREEN_COLOR_TYPE);
    
    gl_FragColor = color_frag * vec4(conColor, 1.0);
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
    
    return mix(interpolColor, oldColor, expositionValue);
}

#pragma mark - Color balance filters

//value = 0.5 - minimal, 1.5 - maximum
vec3 colorBalanceMidtonesOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.5);
    value = min(value, 1.5);
    
    vec3 interpolColor = vec3(oldColor.r, oldColor.g, oldColor.b);
    
    if (colorType == RED_COLOR_TYPE)
        interpolColor.r = 0.0;
    
    if (colorType == GREEN_COLOR_TYPE)
        interpolColor.g = 0.0;
    
    if (colorType == BLUE_COLOR_TYPE)
        interpolColor.b = 0.0;
    
    vec3 result = mix(interpolColor, oldColor, value);
    
    if (colorType == RED_COLOR_TYPE)
    {
        result.g += 1.0 - value;
        result.b += 1.0 - value;
    }
    
    if (colorType == GREEN_COLOR_TYPE)
    {
        result.r += 1.0 - value;
        result.b += 1.0 - value;
    }
    
    if (colorType == BLUE_COLOR_TYPE)
    {
        result.r += 1.0 - value;
        result.g += 1.0 - value;
    }
    
    return result;
}

//value = 0.5 - minimal, 1.5 - maximum
vec3 colorBalanceShadowsOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.5);
    value = min(value, 1.5);
    
    if (value > 1.0)
    {
        if (colorType == RED_COLOR_TYPE)
        {
            oldColor.g += 1.0 - value;
            oldColor.b += 1.0 - value;
        }
        
        if (colorType == GREEN_COLOR_TYPE)
        {
            oldColor.r += 1.0 - value;
            oldColor.b += 1.0 - value;
        }
        
        if (colorType == BLUE_COLOR_TYPE)
        {
            oldColor.g += 1.0 - value;
            oldColor.b += 1.0 - value;
        }
    }
    else
    {
        if (colorType == RED_COLOR_TYPE)
            oldColor.r += value - 1.0;
        
        if (colorType == GREEN_COLOR_TYPE)
            oldColor.g += value - 1.0;
        
        if (colorType == BLUE_COLOR_TYPE)
            oldColor.b += value - 1.0;
    }
    
    return oldColor;
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
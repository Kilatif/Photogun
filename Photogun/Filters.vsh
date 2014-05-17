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

struct coef {
    vec3 add;
    vec3 main;
};

attribute vec4 coord;
attribute highp vec4 color;
attribute vec2 tex_coord;

uniform mat4 projection;
uniform float filters_values[15];
uniform int filters_order[15];

varying vec4 color_frag;
varying vec2 tex_coord_frag;

varying vec2 coefs_R;
varying vec2 coefs_G;
varying vec2 coefs_B;

#pragma mark - interface

//void getCoefsForFilter(int filterType, float filterValue);
coef getCoefsForFilter(int filterType, float filterValue);

coef contrast(vec3 oldColor, float contrastValue);
coef saturation(vec3 oldColor, float saturationValue);
coef brightness(vec3 oldColor, float brightnessValue);

coef exposition(vec3 oldColor, float expositionValue);
coef gammaCorrection(vec3 oldColor, float correctionValue);

coef colorBalanceMidtonesOne(vec3 oldColor, float value, int colorType);
coef colorBalanceShadowsOne(vec3 oldColor, float value, int colorType);
coef colorBalanceLightOne(vec3 oldColor, float value, int colorType);

vec4 colorControl(vec4 oldColor);
vec4 activateFilter(int filterType, vec4 oldColor, float value);
void getCoefsForFilters();

coef testFilter(vec3 oldColor, float testValue);

void main()
{
    color_frag = color;
    tex_coord_frag = tex_coord;
    
    coef tempCoef = getCoefsForFilter(BALANCE_SHADOWS_FILTER_TYPE, filters_values[0]);
    
    coefs_R = vec2(tempCoef.add.r, tempCoef.main.r);
    coefs_G = vec2(tempCoef.add.g, tempCoef.main.g);
    coefs_B = vec2(tempCoef.add.b, tempCoef.main.b);

    
    gl_Position = projection * coord;
}

void getCoefsForFilters()
{
    vec4 color = vec4(0.5, 0.5, 0.5, 1.0);
    float filtersValuesAll = 1.0;
    
    for (int i = 0; i < 15; i++)
    {
        if (filters_order[i] >= 0)
        {
            int filterType = filters_order[i];
            color = activateFilter(filterType, color, filters_values[filterType]);
            
            filtersValuesAll *= filters_values[filterType];
        }
    }
    
    coefs_R = vec2(color.r - filtersValuesAll, filtersValuesAll);
    coefs_G = vec2(color.g - filtersValuesAll, filtersValuesAll);
    coefs_B = vec2(color.b - filtersValuesAll, filtersValuesAll);
}

coef getCoefsForFilter(int filterType, float filterValue)
{
    vec3 unitVector = vec3(1.0, 1.0, 1.0);
    coef result;
    
    if (filterType == BALANCE_SHADOWS_FILTER_TYPE + RED_COLOR_TYPE)
        result = colorBalanceMidtonesOne(unitVector, filterValue, RED_COLOR_TYPE);
    
    return result;
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
    
    
    //if (filterType == CONTRAST_FILTER_TYPE)
    //    result = contrast(oldColor.rgb, value);
    
    //else if (filterType == SATURATION_FILTER_TYPE)
    //    result = saturation(oldColor.rgb, value);
    
    //else if (filterType == BRIGHTNESS_FILTER_TYPE)
    //    result = brightness(oldColor.rgb, value);
    
    //if (filterType == EXPOSITION_FILTER_TYPE)
   //     result = exposition(oldColor.rgb, value);
    
   // else if (filterType == GAMMA_CORRECTION_FILTER_TYPE)
   //     result = gammaCorrection(oldColor.rgb, value);
    
   // if (filterType == BALANCE_MIDTONES_FILTER_TYPE + RED_COLOR_TYPE)
    //    result = colorBalanceMidtonesOne(oldColor.rgb, value, RED_COLOR_TYPE);
    
    //else if (filterType == BALANCE_MIDTONES_FILTER_TYPE + GREEN_COLOR_TYPE)
     //   result = colorBalanceMidtonesOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
    
   // else if (filterType == BALANCE_MIDTONES_FILTER_TYPE + BLUE_COLOR_TYPE)
   //     result = colorBalanceMidtonesOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
   // else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + RED_COLOR_TYPE)
    //    result = colorBalanceShadowsOne(oldColor.rgb, value, RED_COLOR_TYPE);
    
   // else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + GREEN_COLOR_TYPE)
   //     result = colorBalanceShadowsOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
   //
  //  else if (filterType == BALANCE_SHADOWS_FILTER_TYPE + BLUE_COLOR_TYPE)
    //    result = colorBalanceShadowsOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
    //else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + RED_COLOR_TYPE)
    //    result = colorBalanceLightOne(oldColor.rgb, value, RED_COLOR_TYPE);
    
    //else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + GREEN_COLOR_TYPE)
   //     result = colorBalanceLightOne(oldColor.rgb, value, GREEN_COLOR_TYPE);
    
    //else if (filterType == BALANCE_LIGHTS_FILTER_TYPE + BLUE_COLOR_TYPE)
    //    result = colorBalanceLightOne(oldColor.rgb, value, BLUE_COLOR_TYPE);
    
    return vec4(result, 1.0);
}

coef testFilter(vec3 oldColor, float testValue)
{
    coef result;
    vec3 interpol = vec3(0.0, 1.0, 0.0);
    vec3 filterResult = mix(interpol, oldColor, testValue);
    
    result.add = filterResult - testValue;
    result.main = vec3(testValue);
    
    return result;
}

#pragma mark - BCS filters (Brightness, Contrast, Saturation)

//brightnessValue = 0.0 - minimal, 2.0 = maximum
coef brightness(vec3 oldColor, float brightnessValue)
{
    brightnessValue = max(brightnessValue, 0.0);
    brightnessValue = min(brightnessValue, 2.0);
    
    coef result;
    vec3 filterResult;
    
    vec3 avgLumin;
    
    if (brightnessValue < 1.0)
    {
        brightnessValue = 2.0 - brightnessValue;
        avgLumin = vec3(1.0, 1.0, 1.0);
    }
    else
        avgLumin = vec3(0.0, 0.0, 0.0);
    
    filterResult = mix(avgLumin, oldColor.rgb, brightnessValue);
    
    result.add = filterResult - brightnessValue;
    result.main = vec3(brightnessValue);
    
    return result;
}


//contrastValue = 0.5 - minimal, 2.5 = maximum
coef contrast(vec3 oldColor, float contrastValue)
{
    contrastValue = max(contrastValue, 0.5);
    contrastValue = min(contrastValue, 2.5);
    
    vec3 avgLumin = vec3(0.5, 0.5, 0.5);
    
    coef result;
    vec3 filterResult;
    
    filterResult = mix(avgLumin, oldColor.rgb, contrastValue);
    
    result.add = filterResult - contrastValue;
    result.main = vec3(contrastValue);
    
    return result;
}

//saturationValue = 0.0 - minimal, 2.0 - maximum
coef saturation(vec3 oldColor, float saturationValue)
{
    saturationValue = max(saturationValue, 0.0);
    saturationValue = min(saturationValue, 2.0);
    
    vec3 lumCoeff = vec3(0.2155, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(oldColor, lumCoeff));
    
    coef result;
    vec3 filterResult = mix(intensity, oldColor, saturationValue);
    
    result.add = filterResult - saturationValue;
    result.main = vec3(saturationValue);
    
    return result;
}

#pragma mark - Exposition and Gamma-Correction

//expositionValue = 0.0 - minimal, 2.0 - maximal
coef exposition(vec3 oldColor, float expositionValue)
{
    expositionValue = max(expositionValue, 0.0);
    expositionValue = min(expositionValue, 2.0);
    
    vec3 interpolColor = vec3(0.0, 0.0, 0.0);
    
    coef result;
    vec3 filterResult = mix(interpolColor, oldColor, expositionValue);
    
    result.add = filterResult - expositionValue;
    result.main = vec3(expositionValue);
    
    return result;
}

//expositionValue = 0.5 - minimal, 1.5 - maximal
coef gammaCorrection(vec3 oldColor, float correctionValue)
{
    correctionValue = max(correctionValue, 0.5);
    correctionValue = min(correctionValue, 1.5);
    
    vec3 interpolColor = vec3(1.0, 1.0, 1.0);
    
    coef result;
    vec3 filterResult = mix(interpolColor, oldColor, correctionValue);
    
    result.add = filterResult - correctionValue;
    result.main = vec3(correctionValue);
    
    return result;
}

#pragma mark - Color balance filters

//value = 0.5 - minimal, 1.5 - maximum
coef colorBalanceMidtonesOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.5);
    value = min(value, 1.5);
    
    coef gammaColor = gammaCorrection(oldColor, 2.0 - value);
    coef gammaOther = gammaCorrection(oldColor, value);
    
    if (colorType == RED_COLOR_TYPE)
    {
        gammaOther.add.r = gammaColor.add.r;
        gammaOther.main.r = gammaColor.main.r;
    }
    
    if (colorType == GREEN_COLOR_TYPE)
    {
        gammaOther.add.g = gammaColor.add.g;
        gammaOther.main.g = gammaColor.main.g;
    }
    
    if (colorType == BLUE_COLOR_TYPE)
    {
        gammaOther.add.b = gammaColor.add.b;
        gammaOther.main.b = gammaColor.main.b;
    }
    
    return gammaOther;
}

//value = 0.5 - minimal, 1.5 - maximum
coef colorBalanceShadowsOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.0);
    value = min(value, 2.0);
    
    vec3 interpolColor = vec3(1.0, 1.0, 1.0);
    vec3 filterResult;
    coef result;
    
    result.add = vec3(0.0);
    result.main = vec3(1.0);
    
    if (value < 1.0)
    {
        value = 2.0 - value;
        filterResult = mix(interpolColor, oldColor, value);
        if (colorType == RED_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, 0.0, 0.0);
            result.main = vec3(value, 1.0, 1.0);
        }
        
        if (colorType == GREEN_COLOR_TYPE)
        {
            result.add = vec3(0.0, filterResult.g - value, 0.0);
            result.main = vec3(1.0, value, 1.0);
        }
        
        if (colorType == BLUE_COLOR_TYPE)
        {
            result.add = vec3(0.0, 0.0, filterResult.b - value);
            result.main = vec3(1.0, 1.0, value);
        }
    }
    else
    {
        filterResult = mix(interpolColor, oldColor, value);
        if (colorType == RED_COLOR_TYPE)
        {
            result.add = vec3(0.0, filterResult.g - value, filterResult.b - value);
            result.main = vec3(1.0, value, value);
        }
        
        if (colorType == GREEN_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, 0.0, filterResult.b - value);
            result.main = vec3(value, 1.0, value);
        }
        
        if (colorType == BLUE_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, filterResult.g - value, 0.0);
            result.main = vec3(value, value, 1.0);
        }
    }
    
    return result;
}

//value = 0.0 - minimal, 2.0 - maximum
coef colorBalanceLightOne(vec3 oldColor, float value, int colorType)
{
    value = max(value, 0.0);
    value = min(value, 2.0);
    
    vec3 interpolColor = vec3(0.0, 0.0, 0.0);
    vec3 filterResult;
    coef result;
    
    result.add = vec3(0.0);
    result.main = vec3(1.0);
    
    if (value > 1.0)
    {
        filterResult = mix(interpolColor, oldColor, value);
        if (colorType == RED_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, 0.0, 0.0);
            result.main = vec3(value, 1.0, 1.0);
        }
        
        if (colorType == GREEN_COLOR_TYPE)
        {
            result.add = vec3(0.0, filterResult.g - value, 0.0);
            result.main = vec3(1.0, value, 1.0);
        }
        
        if (colorType == BLUE_COLOR_TYPE)
        {
            result.add = vec3(0.0, 0.0, filterResult.b - value);
            result.main = vec3(1.0, 1.0, value);
        }
    }
    else
    {
        value = 2.0 - value;
        filterResult = mix(interpolColor, oldColor, value);
        if (colorType == RED_COLOR_TYPE)
        {
            result.add = vec3(0.0, filterResult.g - value, filterResult.b - value);
            result.main = vec3(1.0, value, value);
        }
        
        if (colorType == GREEN_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, 0.0, filterResult.b - value);
            result.main = vec3(value, 1.0, value);
        }
        
        if (colorType == BLUE_COLOR_TYPE)
        {
            result.add = vec3(filterResult.r - value, filterResult.g - value, 0.0);
            result.main = vec3(value, value, 1.0);
        }
    }
    
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
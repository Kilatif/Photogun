precision highp float;

uniform sampler2D texture;
uniform float redValue;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

const float blurH = 1.0 / 420.0;
const float blurW = 1.0 / 320.0;

vec4 horisontalBlur(int coef);

void main()
{
    int coef = int(redValue);
    
    gl_FragColor = color_frag * horisontalBlur(coef);
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
        
        sum += texture2D(texture, vec2(tex_coord_frag.x, tex_coord_frag.y - offset_l)) * persent_l;
        sum += texture2D(texture, vec2(tex_coord_frag.x, tex_coord_frag.y + offset_r)) * persent_r;
        
        //sum += texture2D(texture, vec2(tex_coord_frag.x - offset_l, tex_coord_frag.y)) * persent_l /2.0;
        //sum += texture2D(texture, vec2(tex_coord_frag.x + offset_r, tex_coord_frag.y)) * persent_r /2.0;
    }
    
    float persent = (float(coef) * d + a) / 100.0;
    sum += texture2D(texture, vec2(tex_coord_frag.x, tex_coord_frag.y)) * persent;
    
    return sum;
}
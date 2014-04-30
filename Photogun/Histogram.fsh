precision highp float;

uniform sampler2D texture;
uniform int histoEnable;
uniform float histogram[256];

varying vec4 color_frag;
varying vec2 tex_coord_frag;

const float histo_width = 256.0;
const float histo_height = 200.0;

const float view_width = 300.0;
const float view_height = 400.0;

vec2 correctCoord(vec2 oldVec);
float histoMax();

void main()
{
    vec4 color_tex = texture2D(texture, tex_coord_frag.st);
           
    gl_FragColor = color_frag * color_tex;
}

vec2 correctCoord(vec2 oldVec)
{
    return vec2(1.0 - oldVec.y, oldVec.x);
}
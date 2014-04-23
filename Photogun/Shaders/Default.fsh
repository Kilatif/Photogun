precision highp float;

uniform sampler2D texture;
uniform float redValue;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

void main()
{
    vec4 tex_color = texture2D(texture, tex_coord_frag);
    
    tex_color.r += redValue;
    gl_FragColor = color_frag * tex_color;
}
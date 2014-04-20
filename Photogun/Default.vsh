attribute vec4 coord;
attribute highp vec4 color;
attribute vec2 tex_coord;

uniform mat4 projection;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

void main()
{
    color_frag = color;
    tex_coord_frag = tex_coord;
    
    gl_Position = projection * coord;
}
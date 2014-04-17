attribute vec2 coord;
attribute highp vec4 color;

varying vec4 color_v;

void main()
{
    gl_Position = vec4(coord, 0.0, 1.0);
    
    color_v = color;
}
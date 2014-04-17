precision highp float;
uniform vec4 color;

varying vec4 color_v;

void main()
{
    gl_FragColor = color_v;
}
precision highp float;

uniform sampler2D texture;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

void main()
{
     gl_FragColor = color_frag * texture2D(texture, tex_coord_frag.st);
}
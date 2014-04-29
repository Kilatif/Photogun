precision highp float;

uniform sampler2D texture;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

void main()
{
    vec4 color_tex = texture2D(texture, tex_coord_frag.st);
    
//    color_tex.r += 0.5;
    //if (tex_coord_frag.x < 0.5)
     //   color_tex = vec4(1.0,1.0,1.0,1.0);
        
        
    gl_FragColor = color_frag * color_tex;
}
precision highp float;

uniform sampler2D texture;

varying vec4 color_frag;
varying vec2 tex_coord_frag;

const float outerRadius = 0.6, innterRadius = 0.2, intensity = 0.8;


void main()
{
    vec4 color = color_frag * texture2D(texture, tex_coord_frag.st);
    vec2 u_resolution = vec2(300.0, 400.0);
    
    vec2 relativePosition = gl_FragCoord.xy / u_resolution - 0.5;
    float len = length(relativePosition);
    float vignette = smoothstep(outerRadius, innterRadius, len);
    color.rgb = mix(color.rgb, color.rgb * vignette, intensity);
    
    gl_FragColor = color;
}

vec4 vignette(vec4 oldColor, float outerRadius, float interRadius, float intensity)
{
    vec2 u_resolution = vec2(300.0, 400.0);
    
    vec2 relativePosition = gl_FragCoord.xy / u_resolution - 0.5;
    float len = length(relativePosition);
    float vignette = smoothstep(outerRadius, innterRadius, len);
    oldColor.rgb = mix(oldColor.rgb, oldColor.rgb * vignette, intensity);
    
    return oldColor;
}
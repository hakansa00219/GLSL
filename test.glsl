
vec3 palette(float t) 
{
    vec3 a = vec3(0.886, 0.446,0.495);
    vec3 b = vec3(0.873, 0.705, 0.337);
    vec3 c = vec3(0.998, 0.058, 0.668);
    vec3 d = vec3(-1.422, 0.808, -1.862);
    return a + b*cos(6.28318*(c*t+d));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {

    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for(float i = 5.0; i > 0.0; i--) {
        uv = fract(uv * 2.0) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0)+  i*.4 + iTime);

        d = cos(d * 8.0 + iTime) / 2.;
        d = abs(d);

        d = pow(0.02 / d, 1.0);

        finalColor += col * d;
    }

    

    fragColor = vec4(finalColor, 1.0); 
    
}
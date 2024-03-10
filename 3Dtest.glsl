float sdSphere( vec3 p, float s )
{
    return length(p)-s;
}
float sdBox( vec3 p, vec3 b )
{
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float smin( float a, float b, float k) {
    float h = max( k - abs(a - b), 0.0) / k;
    return min(a,b) - h * h * h * k * (1.0/6.0);
}

vec3 rot3D(vec3 p, vec3 axis, float angle) {
    // Rodrigues' rotation formula
    return mix(dot(axis,p) * axis, p, cos(angle)) + cross(axis, p) * sin(angle);
}

mat2 rot2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

vec3 palette(float t) 
{
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b*cos(6.28318*(c*t+d));
}

//Distance to the scene
float map(vec3 p) {
    //vec3 spherePos = vec3(2,0,2);
    //vec3 boxPos = vec3(-1,0,-1);

    //float sphere = sdSphere(p - spherePos, length);

    p.z += iTime * 1.;   //movement
    //repetition
    p.xy = fract(p.xy) - .5;
    p.z = mod(p.z, .25) - .125;

    //float boxScale = 0.7;
    float box = sdBox(p,vec3(.05));

    //float ground = p.y + 2.;

    return box; //Closest distance to the scene
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord * 2. - iResolution.xy) / iResolution.y;
    vec2 m = (iMouse.xy * 2. - iResolution.xy) / iResolution.y;

    //Initialization
    vec3 ro = vec3(0, 0, -3);              //ray origin
    vec3 rd = normalize(vec3(uv * 2., 2));      //ray direction
    vec3 col = vec3(0);                    //final pixel color         

    float t = 0.;                       //total distance travelled

/*
    //Vertical camera rotation
    ro.yz *= rot2D(-m.y* 2.);
    rd.yz *= rot2D(-m.y* 2.);

    //Horizontal camera rotation
    ro.xz *= rot2D(-m.x* 2.);
    rd.xz *= rot2D(-m.x* 2.);
*/
    if (iMouse.z < 0.) m = vec2(cos(iTime * .2), sin(iTime*.2));

    // Raymarching
    int i;
    for (i = 0; i < 80; i++) {
        vec3 p = ro + rd * t;           //position along the ray

        p.xy *= rot2D(t*.4 * m.x);

        p.y += sin(t*(m.y + 1.)*0.01)*1.;

        float d = map(p);               //current distance to the scene

        t += d;

        if(d < .001 || d > 100.) break;             //early stop if close or distant
    }

    //Coloring
    col = palette(t*.04 + float(i)*.006);         // color based on distance
    

    fragColor = vec4(col, 1);
}


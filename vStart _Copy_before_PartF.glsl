#version 150

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec2 texCoord;
out vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;


void main()
{
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vPosition).xyz;


    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;

    //***************Part F***********************
    float a = 1.5;
    float b = 0.2;
    float c = 0.5;
    float d = length(Lvec);
    float light_attenuation = 1/(a*pow(d,2) + b*pow(d,1) + c);
    //********************************************

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );   //if L and N face away each other , dot() will give negative light, so use max to cap at 0
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;

    if( dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //***************Part F***********************
    color.rgb = globalAmbient  + ambient + light_attenuation *(diffuse + specular);
    //********************************************
    color.a = 1.0;

    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}

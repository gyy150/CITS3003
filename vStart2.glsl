#version 130

uniform float Shininess;
in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec2 texCoord;
out vec4 color;
out float shine;
out vec3 v_Normal;
out vec3 pos;


// Animation stuff (Part 2)
in ivec4 boneIDs;
in vec4 boneWeights;
uniform mat4 boneTransforms[64];

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;


void main()
{
    // Bone weights
    mat4 finalBoneTransform = boneWeights.x * boneTransforms[boneIDs.x]
    			    + boneWeights.y * boneTransforms[boneIDs.y]
    			    + boneWeights.z * boneTransforms[boneIDs.z]
    			    + boneWeights.w * boneTransforms[boneIDs.w];
    


    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * finalBoneTransform * vPosition).xyz;

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if( dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    color.rgb = globalAmbient  + ambient + diffuse + specular;
    color.a = 1.0;

    // Transform vertex position into eye coordinates , pass it into fragmnet shader
    pos = (ModelView * vPosition).xyz;

     /* Transform vertex normal into eye coordinates 
    (assumes scaling is uniform across dimensions)
    and pass the normal in eye coordinate to fragment shader */

    vec3 v_Normal = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}
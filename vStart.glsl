#version 130

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec3 v_Normal;
out vec3 pos;
out vec2 texCoord;

//*************************
    in ivec4 boneIDs;
    in  vec4 boneWeights;
    uniform mat4 boneTransforms[64];
//**************************

uniform mat4 ModelView;
uniform mat4 Projection;



void main()
{
	mat4 boneTransform = boneWeights[0] * boneTransforms[boneIDs[0]] +
                         boneWeights[1] * boneTransforms[boneIDs[1]] +
                         boneWeights[2] * boneTransforms[boneIDs[2]] +
                         boneWeights[3] * boneTransforms[boneIDs[3]];

    // Transform vertex position into eye coordinates , pass it into fragmnet shader
    pos = (ModelView * boneTransform * vPosition).xyz;

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView * boneTransform * vec4(vNormal, 0.0)).xyz );

    //and pass the normal in eye coordinate to fragment shader
    v_Normal = N;

    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}

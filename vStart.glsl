#version 130

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec3 v_Normal;
out vec3 pos;
out vec2 texCoord;



uniform mat4 ModelView;
uniform mat4 Projection;



void main()
{
    // Transform vertex position into eye coordinates , pass it into fragmnet shader
    pos = (ModelView * vPosition).xyz;

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    //pass the normal in eye coordinate to fragment shader
    v_Normal = N;

    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}

#version 330


uniform sampler2D InSampler;
uniform sampler2D EntityOutlineSampler;
uniform sampler2D MainDepthSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 ScreenSize;
};

layout(std140) uniform FogConfig {
    
    float FOV;
};

out vec4 fragColor;

float near = 0.1; 
float far  = 1000.0;
float LinearizeDepth(float depth) 
{
    float z = depth * 2.0 - 1.0;
    return (near * far) / (far + near - z * (far - near));    
}


void main(){ 
    float FogStartDepth = float(256 * texture(EntityOutlineSampler, vec2(0.6,0.5)).r);
    float FogEndDepth = float(256 * texture(EntityOutlineSampler, vec2(0.6,0.5)).g);
    vec4 FogColour = texture(EntityOutlineSampler, vec2(0.4,0.5));
    float BlockDepth = LinearizeDepth(texture(MainDepthSampler, texCoord).r);
    float BlockDistance = length(vec3(1., (2.*texCoord - 1.) * vec2(ScreenSize.x/ScreenSize.y,1.) * tan(radians(FOV / 2.))) * BlockDepth);
    if(BlockDistance > FogStartDepth && BlockDistance <FogEndDepth) {
        //is within fog draw range
        float FogFadeLength = float( FogEndDepth - FogStartDepth );
        float FogIntensity = float( ( BlockDistance - FogStartDepth) / FogFadeLength);
        fragColor = mix(texture(InSampler, texCoord), FogColour, FogIntensity);
    } else if(BlockDistance >= FogEndDepth) {
        fragColor = FogColour;
    } else {
        fragColor = texture(InSampler, texCoord);
    }
}



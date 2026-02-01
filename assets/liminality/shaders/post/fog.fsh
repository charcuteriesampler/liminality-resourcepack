#version 330

#moj_import <liminality:util.glsl>

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

void main(){ 
    vec4 InputData = texture(EntityOutlineSampler, GFX_INPUT_2);
    vec4 FogColour = texture(EntityOutlineSampler, GFX_INPUT_1);

    float FogStartDepth = InputData.r * 256;
    float FogEndDepth = InputData.g * 256;
    
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

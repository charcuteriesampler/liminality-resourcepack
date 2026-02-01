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
    vec4 InputData = texture(EntityOutlineSampler, GFX_INPUT_3);

    float AmbientBrightness = float(InputData.r);
    float FlashlightPower = InputData.g * 256;

    float BlockDepth = LinearizeDepth(texture(MainDepthSampler, texCoord).r);
    float BlockDistance = length(vec3(1., (2.*texCoord - 1.) * vec2(ScreenSize.x/ScreenSize.y,1.) * tan(radians(FOV / 2.))) * BlockDepth) + 1;
    
    float DistanceFromScreenCenter = distance(vec2(texCoord*vec2(ScreenSize.x/ScreenSize.y,1.)), vec2(vec2(ScreenSize.x/ScreenSize.y,1.) * 0.5));

    float FlashlightDirectionAccuracy = 0.4 - DistanceFromScreenCenter;

    float FlashlightBrightness = (FlashlightPower / BlockDistance / BlockDistance) * FlashlightPower * FlashlightDirectionAccuracy;
    float Brightness = AmbientBrightness;
    if (FlashlightBrightness > 0.0) {
        Brightness += FlashlightBrightness;
    }
    
    fragColor = (texture(InSampler, texCoord)* Brightness);
}

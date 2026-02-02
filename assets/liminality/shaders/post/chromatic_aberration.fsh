#version 330


uniform sampler2D InSampler;

in vec2 texCoord;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 ScreenSize;
};

layout(std140) uniform ChromaticAberrationConfig {
    
    vec2 RShift;
    vec2 GShift;
    vec2 BShift;
};

out vec4 fragColor;



void main(){ 

    float Red = texture(InSampler, vec2(texCoord + RShift)).r;
    float Green = texture(InSampler, vec2(texCoord + GShift)).g;
    float Blue = texture(InSampler, vec2(texCoord + BShift)).b;
    
    //fragColor = vec4(Red, Green, Blue, 1);
    fragColor = vec4(1, 1, 1, 1);

}

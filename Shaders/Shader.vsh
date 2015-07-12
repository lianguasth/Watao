//
//  Shader.vsh
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;
varying vec2 texCoordOut;


uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float height;
uniform float radius[50];

attribute vec2 texCoordIn;

void main()
{
    vec3 lightPosition = vec3(1.0, -1.0, 5.0);
    vec4 amibientColor = vec4(0.35, 0.35, 0.35, 1.0);
    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    vec4 specularColor = vec4(1.0,1.0,1.0,1.0);
    vec3 eyePosition = vec3(0.0,0.0,4.0);
    float shininess = 32.0;
    //use build in parameter
    vec3 ECPosition = (modelViewProjectionMatrix*position).xyz;
    vec3 L = normalize(lightPosition - ECPosition);
    vec3 V = normalize(eyePosition - ECPosition);
    vec3 N = normalize(normalMatrix * normal);
    vec3 H = normalize((V + L));
    vec4 diffuse = diffuseColor * max(dot(N , L) , 0.0);
    vec4 specular = specularColor * pow(max(dot(N , H) , 0.0) , shininess);
    colorVarying = diffuse + specular + amibientColor;
//    colorVarying = diffuse;
    //calculate the right position
    gl_Position = modelViewProjectionMatrix*position;
    texCoordOut = texCoordIn;
}

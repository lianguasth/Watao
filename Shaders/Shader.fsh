//
//  Shader.fsh
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

varying lowp vec4 colorVarying;

varying lowp vec2 texCoordOut;
uniform sampler2D texture;
//this varible will be useful only when using multiple textures

void main()
{
    gl_FragColor = colorVarying*texture2D(texture, texCoordOut);
//    gl_FragColor = colorVarying;
}

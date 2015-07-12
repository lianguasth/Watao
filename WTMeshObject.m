//
//  WTMeshObject.m
//  Watao
//
//  Created by 连 承亮 on 14-3-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTMeshObject.h"

@implementation WTMeshObject

@synthesize textureID;

-(id)init{
    if(self = [super init]){
        return self;
    }
    NSLog(@"initial failed!");
    return nil;
}


-(GLKMatrix4) getModelProjectionViewMatrix{
    return _modelViewProjectionMatrix;
}
-(GLKMatrix3) getNormalMatrix{
    return _normalMatrix;
}
-(Vertex *)getVertices{
    return _vertices;
}
-(GLushort *)getIndices{
    return _indices;
}
-(GLint)getVertexCount{
    return _vertexCount;
}
-(GLint)getIndexCount{
    return _indexCount;
}
-(GLfloat)getHeight{
    return _height;
}

-(void)setModelProjectionViewMatrix:(GLKMatrix4)matrix{
    _modelViewProjectionMatrix = matrix;
}

-(void)dealloc{
    //with ARC, it will call super dealloc automatically
    free(_vertices);
    free(_indices);
    //FIXME this might not be called
}

-(void)moveRotate:(float) rotate scale: (GLKVector3) scale translate:(GLKVector3)translate base:(GLKMatrix4)baseModelViewMatrix project:(GLKMatrix4) projectionMatrix{
    // Compute the model view matrix for the object rendered with ES2
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(translate.x, translate.y, translate.z);
    //at last tranlsate
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, rotate);
    //then rotate
    modelViewMatrix = GLKMatrix4ScaleWithVector3(modelViewMatrix, scale);
    //first scale
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    //set to position in the scene
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    //project it into view
}

//load image into the memory with the right format
//2^n like: 128*128 or 256*256
- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }     // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);     // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);

    free(spriteData);
    textureID = texName;
    return texName;

}

- (id)initUsingOBJWithPath:(NSString *)name
{
    NSStringEncoding encoding;
    NSError *error;
    NSString * pathName = [[NSBundle mainBundle] pathForResource:name ofType:@"obj"];
	NSString *objData = [NSString stringWithContentsOfFile:pathName usedEncoding:&encoding error:&error];
    NSMutableArray *verticeLines = [[NSMutableArray alloc] init];
    NSMutableArray *textureLines = [[NSMutableArray alloc] init];
    NSMutableArray *normalLines = [[NSMutableArray alloc] init];
    NSMutableArray *verticeIndiceLines = [[NSMutableArray alloc] init];
    NSMutableArray *textureIndiceLines = [[NSMutableArray alloc] init];
    NSMutableArray *normalIndiceLines = [[NSMutableArray alloc] init];
    if([self init]==nil){
        return nil;
    }
    if(error !=nil){
        NSLog(@"an error happens while loading OBJ %@",error);
    }else{
        //if file readin normally
        NSArray *lines = [objData componentsSeparatedByString:@"\n"];
        for(NSString *line in lines){
            NSArray *parts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if([line hasPrefix:@"v "]){
                [verticeLines addObject:[parts subarrayWithRange:NSMakeRange(1, 3)]];
            }else if([line hasPrefix:@"vt "]){
                [textureLines addObject:[parts subarrayWithRange:NSMakeRange(1, 2)]];
            }else if([line hasPrefix:@"vn "]){
                [normalLines addObject:[parts subarrayWithRange:NSMakeRange(1, 3)]];
            }else if([line hasPrefix:@"f "]){
                NSArray *faces = [parts subarrayWithRange:NSMakeRange(1, 3)];
                NSArray *face1 = [[faces objectAtIndex:0] componentsSeparatedByString:@"/"];
                NSArray *face2 = [[faces objectAtIndex:1] componentsSeparatedByString:@"/"];
                NSArray *face3 = [[faces objectAtIndex:2] componentsSeparatedByString:@"/"];
                [verticeIndiceLines addObject:[face1 objectAtIndex:0]];
                [verticeIndiceLines addObject:[face2 objectAtIndex:0]];
                [verticeIndiceLines addObject:[face3 objectAtIndex:0]];
                
                [textureIndiceLines addObject:[face1 objectAtIndex:1]];
                [textureIndiceLines addObject:[face2 objectAtIndex:1]];
                [textureIndiceLines addObject:[face3 objectAtIndex:1]];
                
                [normalIndiceLines addObject:[face1 objectAtIndex:2]];
                [normalIndiceLines addObject:[face2 objectAtIndex:2]];
                [normalIndiceLines addObject:[face3 objectAtIndex:2]];                
            }
        }
        //rearrange the vertex, regard one index <---> one vertex rather than one vertex <---> multi Index
        _indexCount = [verticeIndiceLines count];
        _vertexCount = [verticeIndiceLines count];
        _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
        _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
        for(int i = 0; i < [verticeIndiceLines count]; i++){
            _indices[i] = i;
            int ind;
            ind = [[verticeIndiceLines objectAtIndex:i] intValue]-1;
//            float  test = [[verticeLines objectAtIndex: ind*3] floatValue];
            _vertices[i].coord = GLKVector4Make([[[verticeLines objectAtIndex: ind] objectAtIndex:0] floatValue], [[[verticeLines objectAtIndex: ind] objectAtIndex:1] floatValue], [[[verticeLines objectAtIndex: ind] objectAtIndex:2] floatValue], 1.0f);
            ind = [[normalIndiceLines objectAtIndex:i] intValue]-1;
            _vertices[i].normal = GLKVector4Make([[[normalLines objectAtIndex: ind] objectAtIndex:0] floatValue], [[[normalLines objectAtIndex: ind] objectAtIndex:1] floatValue], [[[normalLines objectAtIndex: ind]objectAtIndex:2] floatValue], 1.0f);
            ind = [[textureIndiceLines objectAtIndex:i] intValue]-1;
            _vertices[i].textureCoords  = GLKVector2Make([[[textureLines objectAtIndex: ind] objectAtIndex:0] floatValue], [[[textureLines objectAtIndex: ind] objectAtIndex:1] floatValue]);
        }
    }
    return self;
}


@end

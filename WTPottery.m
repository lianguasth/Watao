#import "WTPottery.h"

@implementation WTPottery

//@synthesize vertex = _vertices;

-(id)WTPotteryIH:(float)initHeight IR:(float)initRadius MINH:(float)minHeight MINR:(float)minRadius MAXH:(float)maxHeight MAXR:(float)maxRadius TH:(float)thickness{   
    _thickness = thickness;
    _height = initHeight;
    _vertexCount = WT_NUM_LEVEL*WT_NUM_VERTEX*2;
    _indexCount = ((WT_NUM_LEVEL-1)*WT_NUM_VERTEX*2+WT_NUM_VERTEX)*3*2;
    _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
    _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
    for (int i = 0; i < WT_NUM_LEVEL; i++) {
        _radius[i] = initRadius;
    }
    //initial the basic data of the pottery
    _boundingBox.minHeight = minHeight;
    _boundingBox.minRadius = minRadius;
    _boundingBox.maxHeight = maxHeight;
    _boundingBox.maxRadius = maxRadius;
    _boundingBox.height = initHeight;
    _boundingBox.maxRadiusNow = initRadius;
    //initial the bounding box
    WTPottery *me = [self init];
    return me;
}


/**
 * initial with position and normal of the vertex
 **/

-(void)initVertex{
    int vertexMinusOne = WT_NUM_VERTEX-1;
    //in order to make a complete loop of the wrist of the pottery
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            float y = _height*i/WT_NUM_LEVEL;
            float x = _radius[i]*cos(2.0*j*M_PI/vertexMinusOne);
            float z = _radius[i]*sin(2.0*j*M_PI/vertexMinusOne);
            _vertices[i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            _vertices[i*WT_NUM_VERTEX+j].normal=GLKVector4Make(x/_radius[i], (float)0.0f, z/_radius[i], 1.0f);
            _vertices[i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //put raw position data into GPU and let it calculate for me then
            float innerRadius = _radius[i]-_thickness;
            x = innerRadius*cos(2.0*j*M_PI/vertexMinusOne);
            z = innerRadius*sin(2.0*j*M_PI/vertexMinusOne);
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].coord=GLKVector4Make(x, y, z, 1.0f);
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX + i*WT_NUM_VERTEX+j].normal=GLKVector4Make(-x/innerRadius, (float)0.0f, -z/innerRadius, 1.0f);
            _vertices[WT_NUM_LEVEL*WT_NUM_VERTEX+i*WT_NUM_VERTEX+j].textureCoords = GLKVector2Make((float)j*1.0f/(float)vertexMinusOne, i*1.0f/(float)WT_NUM_LEVEL);
            //FIXME put right normal value into shader
        }
    }
}

-(void)initIndex{
    int k = WT_NUM_VERTEX*(WT_NUM_LEVEL-1)*6;
    int m = WT_NUM_LEVEL*WT_NUM_VERTEX;
    int d = WT_NUM_VERTEX*(WT_NUM_LEVEL-1);
    for(int i = 0; i < WT_NUM_LEVEL-1; i++){
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            _indices[(i*WT_NUM_VERTEX+j)*6+0] = (GLushort)(i*WT_NUM_VERTEX+j);
            _indices[(i*WT_NUM_VERTEX+j)*6+1] = (GLushort)(i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+2] = (GLushort)((i+1)*WT_NUM_VERTEX+j);
            
            _indices[(i*WT_NUM_VERTEX+j)*6+3] = (GLushort)(i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+4] = (GLushort)((i+1)*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[(i*WT_NUM_VERTEX+j)*6+5] = (GLushort)((i+1)*WT_NUM_VERTEX+j);


            //initial the index of the outside triangles
            _indices[k+(i*WT_NUM_VERTEX+j)*6+0] = (GLushort)(m+i*WT_NUM_VERTEX+j);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+1] = (GLushort)(m+i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+2] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+j);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+3] = (GLushort)(m+i*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+4] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+(j+1)%WT_NUM_VERTEX);
            _indices[k+(i*WT_NUM_VERTEX+j)*6+5] = (GLushort)(m+(i+1)*WT_NUM_VERTEX+j);
            //initial the index of the inside triangles

        }
    }
    for (int i = 0; i < WT_NUM_VERTEX; i++){
        _indices[k*2+i*6 + 0] = (GLushort)(d+i);
        _indices[k*2+i*6 + 1] = (GLushort)(d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 2] = (GLushort)(m+d+i);
        _indices[k*2+i*6 + 3] = (GLushort)(d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 4] = (GLushort)(m+d+(i+1)%WT_NUM_VERTEX);
        _indices[k*2+i*6 + 5] = (GLushort)(m+d+i);
    }
    //initial the index of rim triangles
}

-(void)initTexture{
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        for(int j = 0; j < WT_NUM_VERTEX; j++){
            
        }
    }
}

-(id)init{
    if(self = [super init]){
        [self initVertex];
        [self initIndex];
        return self;
    }
    NSLog(@"initial failed!");
    return self;
}


-(GLfloat *)getRadius{
    return _radius;
}


-(void)updateVertex{
    [self initVertex];
}

-(float)gaussianDelta:(float)delta Mean:(float)mean X:(float)x{
    
    return 1.0f / delta / (float) sqrt( 2 * M_PI ) * (float) exp( - ( x - mean ) * ( x - mean ) / 2 / delta / delta );
    
}

-(void)taller:(float)y : (float)scale :(float)distance{
    if([self withinBoundingBox:y :scale :distance]){
        if(_height < _boundingBox.maxHeight){
            _height+=0.15f;
            _boundingBox.height = _height;
            [self updateVertex];
        }
    }
}

-(void)shorter:(float)y : (float)scale :(float)distance{
    if([self withinBoundingBox:y :scale :distance]){
        if(_height > _boundingBox.minHeight){
            _height-=0.15f;
            _boundingBox.height = _height;
            [self updateVertex];
        }
    }
}

-(void)fatter:(float) y
             :(float)scale
             :(float)distance{
    int touchedLevel = y*WT_NUM_LEVEL/_height*scale;
    if([self withinBoundingBox:y :scale :distance]){
        if(_radius[touchedLevel]<_boundingBox.maxRadius){
            //touching it and it could get larger
            for(int i = 0; i < WT_NUM_LEVEL; i++){                
                float temp = (float)atan((_boundingBox.maxRadius-_radius[i])*2.0/M_PI);
                _radius[i] = _radius[i]+(GLfloat)temp*0.01f*[self gaussianDelta:0.2f Mean:0.0f X:_height*scale*(float)i/(float)WT_NUM_LEVEL - y];
            }
            _boundingBox.maxRadiusNow = [self findMaxRadiusNow];
            [self updateVertex];
        }
    }
}


-(void)thinner:(float) y
              :(float)scale
              :(float)distance{
    int touchedLevel = y*WT_NUM_LEVEL/_height*scale;
    if ([self withinBoundingBox:y :scale :distance]) {
        if(_radius[touchedLevel]>_boundingBox.minRadius){
            //touching it and it could get smaller
            for (int i = 0; i < WT_NUM_LEVEL; i ++){
                float temp = (float) atan((_radius[i]-_boundingBox.minRadius)*2.0f/M_PI);
                _radius[i] = _radius[i]-(GLfloat)temp*0.01f*[self gaussianDelta:0.2f Mean:0.0f X:(_height*scale*(float)i/(float)WT_NUM_LEVEL)-y];
            }
            _boundingBox.maxRadiusNow = [self findMaxRadiusNow];//update bounding box
            [self updateVertex];
        }
    }
 
}

-(BOOL)withinBoundingBox:(float)y
                        :(float)scale
                        :(float)distance{
    int touchedLevel = y*WT_NUM_LEVEL/_height*scale;
    if(y<=_height*scale && y>=0 && _radius[touchedLevel]+0.2>distance){
        //enlarge the radius twice
        return true;
    }
    else{
        return false;
    }
}

-(float)findMaxRadiusNow{
    float max = _boundingBox.minRadius;
    for(int i = 0; i < WT_NUM_LEVEL; i++){
        if(_radius[i] > max){
            max = _radius[i];
        }
    }
    return max;
}


-(BoundingBox)getBoundingBox{
    return _boundingBox;
}

@end
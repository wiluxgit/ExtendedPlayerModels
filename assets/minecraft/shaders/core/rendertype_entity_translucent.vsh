#version 150

#moj_import <light.glsl>
const vec3 LIGHT0_DIRECTION = vec3(0.2, 1.0, -0.7); // Default light 0 direction everywhere except in inventory
const vec3 LIGHT1_DIRECTION = vec3(-0.2, 1.0, 0.7); // Default light 1 direction everywhere except in nether and inventory

mat3 getWorldMat(vec3 light0, vec3 light1) {
    mat3 V = mat3(LIGHT0_DIRECTION, LIGHT1_DIRECTION, cross(LIGHT0_DIRECTION, LIGHT1_DIRECTION));
    mat3 W = mat3(light0, light1, cross(light0, light1));
    return W * inverse(V);
}

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

out vec4 wx_passColor;  //for debugging
out vec3 wx_passMPos;   //for experimental normal calculation
out vec3 wx_passNormal; //for debugging
out vec2 wx_scalingOrigin; //axis not scaled around MUST be 0
out vec2 wx_scaling;
out vec2 wx_maxUV;
out vec2 wx_minUV;
out vec2 wx_UVDisplacement;
out float wx_isEdited;

#define AS_ROTATED 32   // how long to stretch along normal to simulate 90 deg face
#define AS_8XALIGNED 8

void main() {
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    if(gl_VertexID >= 18*8){ //is second layer
        vec4 topRightPixel = texelFetch(Sampler0, ivec2(0, 0), 0); //Macs can't texelfetch in vertex shader?
 
        if(0==0/*topRightPixel.r == 1.0 && topRightPixel.a == 1.0*/){ 
            int cornerId = gl_VertexID % 4;

            vec3 NormNormal = normalize(Normal);
            vec3 newPos = Position;

            switch (gl_VertexID / 4){
            
            /*case 39: // Bottom hat (18+1)*2+1     TOP LAYER ALLIGNED
                newPos -= Normal/16.0*8.43;
                if(cornerId>=2) 
                    newPos += Normal*-AS_ROTATED;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(60,8)/64.0;
                wx_scaling = vec2(1, AS_ROTATED*2/1.1);   //multiply by TWICE normal offset (1.1 to fix pixel size)
                wx_minUV = vec2(56, 0)/64.0;
                wx_maxUV = vec2(64, 8)/64.0;
                wx_UVDisplacement = vec2(8.0,0)/64.0;
                break;*/

            case 39: // Bottom hat (18+1)*2+1     BASE LAYER ALLIGNED
                if(cornerId>=2) 
                    newPos += Normal*-AS_8XALIGNED;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(48+4,8)/64.0;
                wx_scaling = vec2(1.12, AS_8XALIGNED*2*1.01);
                wx_minUV = vec2(56, 0)/64.0;
                wx_maxUV = vec2(64, 8)/64.0;
                wx_UVDisplacement = vec2(8,0+8)/64.0;
                break;

            case 67: // Right jacket
                if(cornerId == 0 || cornerId == 3) 
                    newPos += Normal*AS_ROTATED;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(16,0)/64.0;
                wx_scaling = vec2(AS_ROTATED*4, 1);
                wx_minUV = vec2(16, 36)/64.0;
                wx_maxUV = vec2(20, 48)/64.0;
                wx_UVDisplacement = vec2(0,0)/64.0;
                break;
            
            case 66: // Left jacket
                if(cornerId == 1 || cornerId == 2) 
                    newPos += Normal*AS_ROTATED;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(32,0)/64.0; //backwards, expands left to right
                wx_scaling = vec2(AS_ROTATED*4, 1);
                wx_minUV = vec2(28, 36)/64.0;
                wx_maxUV = vec2(32, 48)/64.0;
                wx_UVDisplacement = vec2(0,0)/64.0;
                break;

            case 69: // 69 Bottom jacket
                if(cornerId<2) 
                    newPos += Normal*AS_ROTATED;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(0,32)/64.0; 
                wx_scaling = vec2(1, AS_ROTATED*4);
                wx_minUV = vec2(28, 16)/64.0;
                wx_maxUV = vec2(36, 20)/64.0;
                wx_UVDisplacement = vec2(0,-16)/64.0;
                break;

            case 71: // 71 Back jacket
                if(cornerId>=2) 
                   newPos += Normal*4.0/16.0;
                wx_isEdited = 1;
                wx_scalingOrigin = vec2(0, 36)/64.0; 
                wx_scaling = vec2(1,1);
                wx_minUV = vec2(32, 36)/64.0;
                wx_maxUV = vec2(40, 48)/64.0;
                wx_UVDisplacement = vec2(0,0)/64.0;
                break;

            default:
                break;
            }   
            if(wx_isEdited){
                wx_passColor = Color;
                wx_passMPos = -(ModelViewMat * vec4(newPos, 1.0)).xyz;
                gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);
                
            } else {
                gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
            }    
        } else {
            gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        }
    } else {
        gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
        
        //passNormal = Normal;
        //passColor = Color;
    }

    /*
    if(gl_VertexID >= 5*8+4 && gl_VertexID <= 5*8+7){ //back body

        mat3 fromWorld = getWorldMat(Light0_Direction,Light1_Direction);
        mat3 toWorld = inverse(fromWorld);
        vec3 wPos = toWorld*Position;
        vec3 wNorm = toWorld*Normal;

        //float anim = abs(fract(GameTime*600)-0.5)-0.25;

        vec3 wDown = vec3(0,-1,0);
        vec3 wSide = cross(wDown, wNorm);

        if(gl_VertexID == 5*8+4){
            wPos += -wSide/16.0*3;
        } else if(gl_VertexID == 5*8+5){
            wPos += wSide/16.0*3;
        } else if(gl_VertexID == 5*8+6){
            wPos += wSide/16.0*3;
            wPos += wNorm/16*6;
        } else if(gl_VertexID == 5*8+7){
            wPos += -wSide/16.0*3;
            wPos += wNorm/16*6;
        }

        gl_Position = ProjMat * ModelViewMat * vec4(fromWorld*wPos, 1.0);

        overlayColor = vec4(abs(wPos)/4.0,0);
    }*/
    /*
    isEdited = 0;
    if(gl_VertexID >= (18+1)*8+4 && gl_VertexID <= (18+1)*8+7){ //bottom head

        vec3 newPos = Position;
        if(mod(gl_VertexID,8) == 6 || mod(gl_VertexID,8) == 7){ //back side
            newPos += Normal*-AS_ROTATED;
        } else { //front side
            newPos -= Normal/16.0*8.45;
        }
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        passColor = Color;
        passMPos = -(ModelViewMat * vec4(newPos, 1.0)).xyz;
        passInvTrans = mat3(inverse(ProjMat * ModelViewMat));
        isEdited = 1.0;
    }
    */
    //
    /*
    T/B Hat     -> (Front,Back) x (Ears,Beard)
    L/R Hat     -> (Front,Back) x (Side Ears)
    L/R Jacket  -> (Front,Back) x (Wings)
    T/B Jacket  -> (Front,Back,Left,Right) x (Collar,Coat)


    /*
    mat3 fromWorld = getWorldMat(Light0_Direction,Light1_Direction);
    mat3 toWorld = inverse(fromWorld);
    vec3 wPos = toWorld*Position;

    overlayColor = vec4(abs(wPos)/4.0,0);



    /*
    if(gl_VertexID == 14*8+1){  
        overlayColor = vec4(0,1,0,0);
        
        mat3 fromWorld = getWorldMat(Light0_Direction,Light1_Direction);
        mat3 toWorld = inverse(fromWorld);
        vec3 wPos = toWorld*Position;

        vec3 wNorm = toWorld*Normal; //orthogonal to face
        vec3 wPer = wNorm.xzy;

        wPos += wNorm/16;

        vec3 newPos = fromWorld*wPos;

        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0); 
    }
    /*
    
    else if(texCoord0.x == 4.0/64.0){
        overlayColor = vec4(1,1,0,0);

        mat3 fromWorld = getWorldMat(Light0_Direction,Light1_Direction);
        mat3 toWorld = inverse(fromWorld);
        vec3 wPos = toWorld*Position;

        vec3 wNorm = toWorld*Normal; //orthogonal to face
        vec3 wPer = wNorm.xzy;

        wPos += wNorm/16;

        vec3 newPos = fromWorld*wPos;

        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0); 
        
    }
    else if(texCoord0.x == 8.0/64.0){
        overlayColor = vec4(0,1,0,0);
    }*/

    //texCoord0.x += 2;
    //texCoord0.y += 10;

    //overlayColor.r = UV0.x;
    //overlayColor.g = UV0.y;
    //overlayColor.a = 0;
    

}

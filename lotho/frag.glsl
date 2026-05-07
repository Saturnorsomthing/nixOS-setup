// CC0: Sunrise on saturn
// Was tinkering with trying to recreate a sweet sci fi image
// Stopped working and forgot to share at the time.
// I strongly doubt there's mist like blur in space but it looked
// nice on original image so tried to recreate it.

#define TIME        iTime
#define RESOLUTION  iResolution
#define PI          3.141592654
#define TAU         (2.0*PI)

#define TIME        iTime
#define RESOLUTION  iResolution
#define PI          3.141592654
#define TAU         (2.0*PI)

// License: WTFPL, author: sam hocevar, found: https://stackoverflow.com/a/17897228/418488
const vec4 hsv2rgb_K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
vec3 hsv2rgb(vec3 c) {
  vec3 p = abs(fract(c.xxx + hsv2rgb_K.xyz) * 6.0 - hsv2rgb_K.www);
  return c.z * mix(hsv2rgb_K.xxx, clamp(p - hsv2rgb_K.xxx, 0.0, 1.0), c.y);
}
// License: WTFPL, author: sam hocevar, found: https://stackoverflow.com/a/17897228/418488
//  Macro version of above to enable compile-time constants
#define HSV2RGB(c)  (c.z * mix(hsv2rgb_K.xxx, clamp(abs(fract(c.xxx + hsv2rgb_K.xyz) * 6.0 - hsv2rgb_K.www) - hsv2rgb_K.xxx, 0.0, 1.0), c.y))

// License: MIT, author: Inigo Quilez, found: https://www.iquilezles.org/www/articles/spherefunctions/spherefunctions.htm
vec2 raySphere2(vec3 ro, vec3 rd, vec4 sph) {
  vec3 oc = ro - sph.xyz;
  float b = dot(oc, rd);
  float c = dot(oc, oc) - sph.w*sph.w;
  float h = b*b - c;
  if(h<0.0) return vec2(-1.0);
  h = sqrt(h);
  return vec2(-b - h, -b + h);
}

// License: Unknown, author: Claude Brezinski, found: https://mathr.co.uk/blog/2017-09-06_approximating_hyperbolic_tangent.html
float tanh_approx(float x) {
  //  Found this somewhere on the interwebs
  //  return tanh(x);
  float x2 = x*x;
  return clamp(x*(27.0 + x2)/(27.0+9.0*x2), -1.0, 1.0);
}


// License: MIT, author: Inigo Quilez, found: https://iquilezles.org/www/articles/intersectors/intersectors.htm
float rayPlane(vec3 ro, vec3 rd, vec4 p) {
  return -(dot(ro,p.xyz)+p.w)/dot(rd,p.xyz);
}

const float far           = 1E5;
const vec3 sunDir         = normalize(vec3(2.5, -2.0, 10.0));
const float planetRadius  = 425.0;
const vec3 planetCenter   = vec3(0.0, -1.05*planetRadius, 0.0);
const vec4 planetDim      = vec4(planetCenter, planetRadius);
const vec4 surfaceDim     = vec4(planetCenter, 0.95*planetRadius);
const vec3 ringNor        = normalize(vec3(-3.2, 1.0, 1.75));
const vec4 ringDim        = vec4(ringNor, -dot(ringNor, planetCenter));

const vec3 SUNNORM = HSV2RGB(vec3(0.066, 0.66, 0.000025));
const vec3 SUNBLUE = HSV2RGB(vec3(0.64, 0.97, 0.000025));
const vec3 SUNLIME = HSV2RGB(vec3(0.233, 0.84, 0.000025));
const vec3 SUNLAVN = HSV2RGB(vec3(0.69, 0.77, 0.000025));
const vec3 SUNMAUV = HSV2RGB(vec3(0.741, 0.84, 0.000025));

const vec2 RINGNORM = vec2(0.066, 0.85);
const vec2 RINGLAVN = vec2(0.69, 0.77);
const vec2 RINGMAUV = vec2(0.741, 0.84);
const vec2 ringCol = RINGLAVN;

vec3 sky(vec3 ro, vec3 rd) {
  const vec3 sunCol = SUNLAVN;

  float sf = 1.001-dot(rd, sunDir);
//  sf *= sf;
  sf *= sf;
  vec3 col = vec3(0.0);
  col += sunCol/sf;
  return col;
}

vec3 sky(vec3 col, inout float hit, vec3 ro, vec3 rd) {

  if (far > hit) {
    return col;
  }
  hit = 1E5;

  col += sky(ro, rd);


  return col;
}

vec3 planet(vec3 col, inout float hit, vec3 ro, vec3 rd) {
  vec2 pi   = raySphere2(ro, rd, planetDim);
  if (pi.x == -1.0) {
    return col;
  }
  if (pi.x > hit) {
    return col;
  }
  hit = pi.x;
  
  vec3 pos  = ro+rd*pi.x;
  vec3 nor  = normalize(pos-planetDim.xyz);
  float fre = 1.0+dot(rd, nor);
  fre *= fre;
  vec3 refl = reflect(rd, nor);
  float rr = mix(1.0, 0.7, tanh_approx(0.0025*(pi.y-pi.x)));
  vec3 refr = refract(rd, nor, rr);
  
  vec2 pri  = raySphere2(pos, refr, planetDim);
  vec2 sri  = raySphere2(pos, refr, surfaceDim);
  vec3 rpos = pos+refr*pri.y;
  vec3 rnor = normalize(rpos-planetDim.xyz);
  vec3 rrefr= refract(refr, -rnor, rr);
  
  vec3 pcol   = vec3(0.0);
  vec3 prefl  = sky(pos, refl);
  vec3 prefr  = sky(pos, rrefr);
  prefr = pow((prefr), vec3(1.25, 1.0, 0.75));
  pcol += prefl*fre;
  pcol += prefr*(1.0-tanh_approx(0.004*(sri.y-sri.x)));

  float pt = tanh_approx(0.025*(pi.y-pi.x));
  col = mix(col, pcol, pt);
  return col;
}

vec3 rings(vec3 col, inout float hit, vec3 ro, vec3 rd) {
  float pt = rayPlane(ro, rd, ringDim);
  if (pt < 0.0) {
    return col;
  }
  if (pt > hit) {
    return col;
  }
  
  vec3 pos = ro+rd*pt;
  vec3 nor = ringDim.xyz;
  vec2 sri  = raySphere2(pos, sunDir, planetDim);
  vec3 spos = pos+sunDir*sri.x;
  vec3 snor = normalize(spos - planetDim.xyz);
  float sfre = 1.0+dot(sunDir, snor);
//  sfre *= sfre;

  float r = length(pos-planetCenter);
  float rr = 1.0*r;
  float ri0 = sin(.5*rr);
  float ri1 = sin(.2*rr);
  float ri2 = sin(.12*rr);
  float ri3 = sin(.033*rr-2.);
//  float ri = (0.5+0.5*ri0*ri1*ri2);
  float ri = smoothstep(-0.95, 0.75, ri0*ri1*ri2);
  ri = 0.5*ri+0.2*ri3;
  ri *= 1.75;
  float sf = sri.x < 0.0 ? 1.0 : mix(0.05, 1.0, smoothstep(0.5, 1.0, sfre));
  float rdif = max(dot(nor, sunDir), 0.0);
  rdif = sqrt(rdif);
  vec3 rcol = hsv2rgb(vec3(ringCol.x, ringCol.y+0.1*ri0*ri1, ri))*sf*rdif;
  rcol *= smoothstep(550.0, 560.0, r)*smoothstep(860.0, 850.0, r);
  col += rcol;
  return col;
}
vec3 render(vec3 ro, vec3 rd) {
  vec3 col = vec3(0.0);

  float hit = far;
  
  col = sky(col, hit, ro, rd);
  col = planet(col, hit, ro, rd);
  col = rings(col, hit, ro, rd);
  
  return col;
}

vec3 effect(vec2 p) {
  float gd = min(abs(p.x), abs(p.y))-0.005;

  const vec3 ro = vec3(0.0, 0.0, -1000.0);
  const vec3 la = vec3(0.0, 0.0, 0.0);
  const vec3 up = normalize(vec3(0.0, 1.0, 0.0));

  vec3 ww = normalize(la - ro);
  vec3 uu = normalize(cross(up, ww ));
  vec3 vv = (cross(ww,uu));
  const float fov = 4.0;
  vec3 rd = normalize(-p.x*uu + p.y*vv + fov*ww);

  float aa = 4.0/RESOLUTION.y;
  vec3 col = render(ro, rd);
//  col = mix(col, vec3(0.25, 0.0 ,0.), smoothstep(0.0, -aa, gd));
  return col;
}

vec3 mainImageA(vec4 fragColor, vec2 fragCoord) {
  vec2 q = fragCoord/RESOLUTION.xy;
  vec2 p = -1. + 2. * q;
  p.x *= RESOLUTION.x/RESOLUTION.y;
  vec3 col = effect(p);
  return col;
}

#define ROT(a)          mat2(cos(a), sin(a), -sin(a), cos(a))

const mat2 brot = ROT(2.399);
// License: Unknown, author: Dave Hoskins, found: Forgot where
vec3 dblur(vec2 q,float rad) {
  vec3 acc=vec3(0);
  const float m = 0.0025;
  vec2 pixel=vec2(m*RESOLUTION.y/RESOLUTION.x,m);
  vec2 angle=vec2(0,rad);
  rad=1.;
  const int iter = 30;
  /*for (int j=0; j<iter; ++j) {  
    rad += 1./rad;
    angle*=brot;
    vec4 col=texture(iChannel1,q+pixel*(rad-1.)*angle);
    acc+=clamp(col.xyz, 0.0, 10.0);
  }*/
  return acc*(1.0/float(iter));
}

// License: Unknown, author: Matt Taylor (https://github.com/64), found: https://64.github.io/tonemapping/
vec3 aces_approx(vec3 v) {
  v = max(v, 0.0);
  v *= 0.6f;
  float a = 2.51f;
  float b = 0.03f;
  float c = 2.43f;
  float d = 0.59f;
  float e = 0.14f;
  return clamp((v*(a*v+b))/(v*(c*v+d)+e), 0.0f, 1.0f);
}

vec3 mainImageB(vec4 fragColor, vec2 fragCoord ) {
  vec2 q = fragCoord/RESOLUTION.xy;
  vec3 col = mainImageA(fragColor, fragCoord);//texture(iChannel0, q).xyz;
  
  col -= 0.005*vec3(0.0, 1.0, 2.0).zyx;
  col = aces_approx(col);
  col += 0.5*dblur(q, 1.0);
  return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
  vec2 q = fragCoord/RESOLUTION.xy;
  vec3 col = vec3(0.0);
  col = mainImageB(fragColor, fragCoord);//texture(iChannel0, q).xyz;
  col = sqrt(col);

  fragColor = vec4(col, 1.0);
}



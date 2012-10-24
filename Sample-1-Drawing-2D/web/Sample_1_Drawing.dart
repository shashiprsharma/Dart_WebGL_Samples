import 'dart:html';
import 'dart:math';

import 'glmatrix.dart'; 
import 'VertexShader.dart';
import 'FragmentShader.dart';
import 'Shapes.dart';

class WebGl
{
  CanvasElement canvas;
  double aspect;
  WebGLRenderingContext GL;
  WebGLProgram program;
  WebGLUniformLocation pMatrixUniform;
  WebGLUniformLocation mvMatrixUniform;
  Matrix mvMatrixLocal;
  Matrix pMatrixLocal;
  

  bool init(CanvasRenderingContext ctx)
  {
    this.canvas = ctx.canvas;
    this.aspect = ctx.canvas.width/ctx.canvas.height;
    
    this.GL = ctx;
    if(this.GL == null)
    {
      return false;
    }
    
    _initShaders();
    
    this.GL.clearColor(0.0, 0.0, 0.0, 1.0);
    this.GL.enable(WebGLRenderingContext.DEPTH_TEST);
    
    _initScene();
    return true;     
  }
  
  bool _initShaders()
  {
    //Create vertex shader from source and compile
    WebGLShader vertexShader = this.GL.createShader(WebGLRenderingContext.VERTEX_SHADER);
    this.GL.shaderSource(vertexShader, VertexShader.shaderCode);
    this.GL.compileShader(vertexShader);
      
    //Create fragment shader from source and compile
    WebGLShader fragmentShader = this.GL.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
    this.GL.shaderSource(fragmentShader, FragmentShader.shaderCode);
    this.GL.compileShader(fragmentShader);
    
    //Attach the shaders to the program, link them and use the program
    WebGLProgram p = this.GL.createProgram();
    this.GL.attachShader(p, vertexShader);
    this.GL.attachShader(p, fragmentShader);
    this.GL.linkProgram(p);
    this.GL.useProgram(p);
    
    
    if (!this.GL.getShaderParameter(vertexShader, WebGLRenderingContext.COMPILE_STATUS)) { 
      print(this.GL.getShaderInfoLog(vertexShader));
      return false;
    }
    
    if (!this.GL.getShaderParameter(fragmentShader, WebGLRenderingContext.COMPILE_STATUS)) { 
      print(this.GL.getShaderInfoLog(fragmentShader));
      return false;
    }
    
    if (!this.GL.getProgramParameter(p, WebGLRenderingContext.LINK_STATUS)) { 
      print(this.GL.getProgramInfoLog(p));
      return false;
    }
        
    this.program = p; 
    
    VertexShader.vertexPositionAttribute = this.GL.getAttribLocation(program, "aVertexPosition");
    this.GL.enableVertexAttribArray(VertexShader.vertexPositionAttribute);
    
    VertexShader.vertexColorAttribute = this.GL.getAttribLocation(program, "aVertexColor");
    this.GL.enableVertexAttribArray(VertexShader.vertexColorAttribute);
    
    pMatrixUniform = this.GL.getUniformLocation(program, "uPMatrix");
    mvMatrixUniform = this.GL.getUniformLocation(program, "uMVMatrix");
    
    return true;
  }
  
  bool _initScene()
  {
    //Setup Viewport and clear it
    print(this.canvas.width);
    this.GL.viewport(0, 0, this.canvas.width, this.canvas.height);
    this.GL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
    
    mvMatrixLocal = new Matrix.identity();
    pMatrixLocal = new Matrix.identity();
    
    //Setup Perspective and Model view matrix
    //Matrix.Perspective(45.0, aspect, 0.1, 100.0, pMatrixLocal);
    Matrix.Ortho(0.0, this.canvas.width.toDouble(), this.canvas.height.toDouble(), 0.0, 0.0, 10.0, pMatrixLocal);
    Matrix.Identity(mvMatrixLocal);
    

    //setMatrixUniforms();
    return true;
  }
  
  void setMatrixUniforms()
  {
    this.GL.uniformMatrix4fv(pMatrixUniform, false, pMatrixLocal.dest);
    this.GL.uniformMatrix4fv(mvMatrixUniform, false, mvMatrixLocal.dest);
  }
  
  void drawShape(Shape shape)
  {
    
    this.GL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
    //Create Vertex and Color Buffers for the shape
    //Vertex Buffer;    
    WebGLBuffer vertexBuffer = this.GL.createBuffer();
    this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    this.GL.bufferData(WebGLRenderingContext.ARRAY_BUFFER, shape.getVertices(), WebGLRenderingContext.STATIC_DRAW);
    //Color Buffer
    WebGLBuffer colorBuffer = this.GL.createBuffer();
    this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, colorBuffer);
    this.GL.bufferData(WebGLRenderingContext.ARRAY_BUFFER, shape.getColors(), WebGLRenderingContext.STATIC_DRAW);
    
    //mvMatrixLocal.recycle();
    //mvMatrixLocal = new Matrix.identity();
    //mvMatrixLocal.translate(new Vector3(0.0,0.0,-5.0));
    
    //Put vertex and color in the buffer and draw
    //Vertex Buffer
    this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    this.GL.vertexAttribPointer(VertexShader.vertexPositionAttribute, 3, WebGLRenderingContext.FLOAT, false, 0, 0);
    //Color Buffer
    this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, colorBuffer);
    this.GL.vertexAttribPointer(VertexShader.vertexColorAttribute, 4, WebGLRenderingContext.FLOAT, false, 0, 0);
    
    //print(shape.getNumVertices());
    setMatrixUniforms();
    this.GL.drawArrays(WebGLRenderingContext.TRIANGLE_FAN, 0, shape.getNumVertices());
    
  }
  
  void drawShapes(List allShapes)
  {
    this.GL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
    for(int i = 0; i<allShapes.length; i++)
    {
      
      Shape shape = allShapes[allShapes.length-(i+1)];
    
      
      //Create Vertex and Color Buffers for the shape
      //Vertex Buffer;    
      WebGLBuffer vertexBuffer = this.GL.createBuffer();
      this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
      this.GL.bufferData(WebGLRenderingContext.ARRAY_BUFFER, shape.getVertices(), WebGLRenderingContext.STATIC_DRAW);
      //Color Buffer
      WebGLBuffer colorBuffer = this.GL.createBuffer();
      this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, colorBuffer);
      this.GL.bufferData(WebGLRenderingContext.ARRAY_BUFFER, shape.getColors(), WebGLRenderingContext.STATIC_DRAW);
      
      //mvMatrixLocal.recycle();
      //mvMatrixLocal = new Matrix.identity();
      //mvMatrixLocal.translate(new Vector3(0.0,0.0,-5.0));
      
      //Put vertex and color in the buffer and draw
      //Vertex Buffer
      this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
      this.GL.vertexAttribPointer(VertexShader.vertexPositionAttribute, 3, WebGLRenderingContext.FLOAT, false, 0, 0);
      //Color Buffer
      this.GL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, colorBuffer);
      this.GL.vertexAttribPointer(VertexShader.vertexColorAttribute, 4, WebGLRenderingContext.FLOAT, false, 0, 0);
      
      //print(shape.numOfVertices);
      setMatrixUniforms();
      this.GL.drawArrays(WebGLRenderingContext.TRIANGLE_FAN, 0, shape.getNumVertices());
    }
  }
  
  void clearViewPort(){
    this.GL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
  }
  
 
}

class Color
{
  double R;
  double G;
  double B;
  double A;
  
  Color(this.R,this.G,this.B,this.A);
}
class Pos
{
  double X;
  double Y;
}


WebGl gl;
final int TRIANGLE_SELECT = 1;
final int RECTANGLE_SELECT = 2;
ButtonElement triangle_btn;
ButtonElement rectangle_btn;

num selectedShape;
Color selectedColor;
bool isDrawing;
bool isNewDrawing;
Pos canvasPos;
Pos startMousePos;

List<Shape> allShapes;

void main() {  
  
  CanvasElement canvas; 
  CanvasRenderingContext ctx;
  canvas =  query("#canvas1");  
  ctx = canvas.getContext("experimental-webgl");  
  canvas.style.setProperty("cursor", "crosshair");
  
  gl = new WebGl();
  gl.init(ctx);
  
  selectedShape = TRIANGLE_SELECT;
  selectedColor = new Color(1.0,1.0,1.0,1.0);
  allShapes = new List();
  isDrawing = false;
  isNewDrawing = false;
  canvas.on.mouseDown.add(handleCanvasMouseDown);
  canvas.on.mouseUp.add(handleCanvasMouseUp);
  canvas.on.mouseMove.add(handleCanvasMouseMove);
  
  triangle_btn = query("#triangle_button");
  rectangle_btn = query("#rectangle_button");
  triangle_btn.on.mouseDown.add(handleTriangleBtnMouseDown);
  rectangle_btn.on.mouseDown.add(handleRectangleBtnMouseDown);
  
  InputElement colorPicker = query("#colorpick");
  ButtonElement clearButton = query("#clear_button");
  colorPicker.value = "#FFFFFF";
  colorPicker.on.change.add((Event e){
    selectedColor = colorHexToGL((e.target as InputElement).value);
  });
  
  clearButton.on.click.add((Event e){
    allShapes.clear();
    gl.clearViewPort();
  });
}

int hexToInt(String hex) {
  int val = 0;

  int len = hex.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = hex.charCodeAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new Exception("Bad hexidecimal value");
    }
  }

  return val;
}

Color colorHexToGL(String hexColor)
{
  hexColor = hexColor.replaceAll('#', '');
 // print(hexColor);

  double R = ((hexToInt(hexColor[0]) * 16) + hexToInt(hexColor[1])).toDouble()/255.0;
  double G = ((hexToInt(hexColor[2]) * 16) + hexToInt(hexColor[3])).toDouble()/255.0;
  double B = ((hexToInt(hexColor[4]) * 16) + hexToInt(hexColor[5])).toDouble()/255.0;
 
  Color ret = new Color(R,G,B,1.0);
  return ret;
  
}


handleTriangleBtnMouseDown(MouseEvent e){
  
  (e.currentTarget as ButtonElement).style.setProperty("background", "#ffffff");
  (e.currentTarget as ButtonElement).style.setProperty("border-style", "inset");
  rectangle_btn.style.setProperty("background", "#6E6E6E");
  rectangle_btn.style.removeProperty("border-style");
  
  selectedShape = TRIANGLE_SELECT;  
}

handleRectangleBtnMouseDown(MouseEvent e){
  
  (e.currentTarget as ButtonElement).style.setProperty("background", "#ffffff");
  (e.currentTarget as ButtonElement).style.setProperty("border-style", "inset");
  triangle_btn.style.setProperty("background", "#6E6E6E");
  triangle_btn.style.removeProperty("border-style");
 
  selectedShape = RECTANGLE_SELECT;
}

Pos getCanvasMousePosition(MouseEvent e)
{  
  Pos ret = new Pos();
  if(e.offsetX != null) {
    ret.X = e.offsetX.toDouble();
    ret.Y = e.offsetY.toDouble();
  }
  else if(e.layerX != null) {
    ret.X = e.layerX.toDouble();
    ret.Y = e.layerY.toDouble();
  }
  return ret;  
}
handleCanvasMouseDown(MouseEvent e)
{  
  e.preventDefault();
  isDrawing = true;
  isNewDrawing = true;
  startMousePos = getCanvasMousePosition(e);
}

handleCanvasMouseUp(MouseEvent e)
{
  isDrawing = false;
}

handleCanvasMouseMove(MouseEvent e)
{   
  if(isDrawing == true)
  {
    Pos endMousePos = getCanvasMousePosition(e);
    drawShape(startMousePos, endMousePos);
  }
}

void drawShape(Pos start, Pos end)
{
  Shape shape;
  if(selectedShape==TRIANGLE_SELECT)
  { 
    TriangleShape triangle = new TriangleShape(start.X, start.Y, end.X, end.Y);
    //triangle.setSolidColor(1.0, 0.0, 0.0, 1.0);
    triangle.setSolidColor(selectedColor.R, selectedColor.G, selectedColor.B, 1.0);
    shape =triangle;
  }
  else if(selectedShape==RECTANGLE_SELECT)
  {
    RectangleShape rect = new RectangleShape(start.X, start.Y, end.X, end.Y);
    //rect.setSolidColor(0.0, 0.0, 1.0, 1.0);
    rect.setSolidColor(selectedColor.R, selectedColor.G, selectedColor.B, 1.0);
    shape = rect;
  }
  
  if(isNewDrawing == true){
    isNewDrawing = false;
    allShapes.add(shape);
    gl.drawShapes(allShapes);
  }else{    
    allShapes.removeLast();
    allShapes.add(shape);
    gl.drawShapes(allShapes);
  }
}
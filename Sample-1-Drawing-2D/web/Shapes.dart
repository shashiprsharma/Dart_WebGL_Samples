#library("Shapes");
#import('dart:html');
#import('dart:math');


class Shape
{  
  Float32Array _vertices;
  Float32Array _colors;
  int _numOfVertices;
  int _numOfColors;
  
  void _setVertex3V(List vertex1, List vertex2, List vertex3)
  {
    _numOfVertices = 3;
    List vertexList = [];
    vertexList.addAll(vertex1);
    vertexList.addAll(vertex2);
    vertexList.addAll(vertex3);
    _vertices = new Float32Array.fromList(vertexList);
  }
  void _setVertex4V(List vertex1, List vertex2, List vertex3, List vertex4)
  {
    _numOfVertices = 4;
    List vertexList = [];
    vertexList.addAll(vertex1);
    vertexList.addAll(vertex2);
    vertexList.addAll(vertex3);
    vertexList.addAll(vertex4);
    _vertices = new Float32Array.fromList(vertexList);
  }
  
  void _setColorSolid(List color)
  {
    _numOfColors = _numOfVertices;
    List colorList = [];
    for(int i = 0; i< _numOfVertices; i++)
    {
      colorList.addAll(color);
    }
    _colors = new Float32Array.fromList(colorList);
  }
  void _setColor3V(List vertex1, List vertex2, List vertex3)
  {
    _numOfColors = 3;
    List colorList = [];
    colorList.addAll(vertex1);
    colorList.addAll(vertex2);
    colorList.addAll(vertex3);
    _colors = new Float32Array.fromList(colorList);
  }
  void _setColor4V(List vertex1, List vertex2, List vertex3, List vertex4)
  {
    _numOfColors = 4;
    List colorList = [];
    colorList.add(vertex1);
    colorList.add(vertex2);
    colorList.add(vertex3);
    colorList.add(vertex4);
    _colors = new Float32Array.fromList(colorList);
  }
  
  Float32Array getVertices(){
    return _vertices;
  }
  Float32Array getColors(){
    return _vertices;
  }
  
  int getNumVertices(){
    return _numOfVertices;
  }
}

class TriangleShape extends Shape
{
  
  TriangleShape(double startX, double startY, double endX, double endY ){
    List vertex1 = [startX, startY, 0.0];
    List vertex2 = [(endX - ((endX-startX)*2)), endY, 0.0];
    List vertex3 = [endX, endY, 0.0];    
    _setVertex3V(vertex1, vertex2, vertex3);    

  }
  
  void setSolidColor(double R, double G, double B, double A){    
    List color = [R,G,B,A];
    _setColorSolid(color);
  }
  
  void setVertexColor3V(List vertex1, List vertex2, List vertex3){
    _setColor3V(vertex1, vertex2, vertex3);
  }
  
  Float32Array getVertices(){
    return _vertices;
  }
  
  Float32Array getColors(){
    return _colors;
  }
  
  int getNumVertices(){
    return _numOfVertices;
  }
}

class RectangleShape extends Shape
{
  
  RectangleShape(double startX, double startY, double endX, double endY ){
    List vertex2 = [startX, startY, 0.0];
    List vertex3 = [startX, endY, 0.0];
    List vertex4 = [endX, endY, 0.0];
    List vertex1 = [endX, startY, 0.0];
    _setVertex4V(vertex1, vertex2, vertex3, vertex4);    

  }
  
  void setSolidColor(double R, double G, double B, double A){    
    List color = [R,G,B,A];
    _setColorSolid(color);
  }
  
  void setVertexColor3V(List vertex1, List vertex2, List vertex3, List vertex4){
    _setColor4V(vertex1, vertex2, vertex3, vertex4);
  }
  
  Float32Array getVertices(){
    return _vertices;
  }
  
  Float32Array getColors(){
    return _colors;
  }
  
  int getNumVertices(){
    return _numOfVertices;
  }
}
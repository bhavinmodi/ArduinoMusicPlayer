
  /* For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */
import processing.serial.*;
import ddf.minim.*;

Minim minim;
//AudioPlayer player;
Serial myPort;
AudioPlayer[] player=new AudioPlayer[6];
AudioPlayer song;
int count=0;
int started=0;
float volume=-25;
AudioMetaData meta;
int fast=0;

void setup()
{
  size(512, 230);
  
  String portName = "COM14";
  myPort = new Serial(this, portName, 9600);
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  player[0]=minim.loadFile("jingle.mp3");
  player[1]=minim.loadFile("numb.mp3");
  player[2]=minim.loadFile("carnival of rust.mp3");
  player[3]=minim.loadFile("in the end.mp3");
  player[4]=minim.loadFile("diary of jane.mp3");
  player[5]=minim.loadFile("bangarang.mp3");
  
  // play the file from start to finish.
  // if you want to play the file again, 
  // you need to call rewind() first.
}

void draw()
{ 
  background(0);
  stroke(255);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  
  song=player[count];
  meta=song.getMetaData();
  text(meta.fileName(),10,220);
  text(meta.author(),150,220);
  for(int i = 0; i < song.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, song.bufferSize(), 0, width );
    float x2 = map( i+1, 0, song.bufferSize(), 0, width );
    line( x1, 50 + song.left.get(i)*50, x2, 50 + song.left.get(i+1)*50 );
    line( x1, 150 + song.right.get(i)*50, x2, 150 + song.right.get(i+1)*50 );
  }
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  println(inByte);
  
  //Switch to next song automatically
  if(started==1){
    if(!player[count].isPlaying()){
      player[count].rewind();
      count++; 
      if(count>5){
        count=0;
      }
      player[count].play();
    }
   draw();
  }
  
  // 1 knock causes the song to pause or play
  if(inByte==1){
    if(player[count].isPlaying()){
      player[count].pause();
      started=0;
    }
    else{
      player[count].play();
      started=1;
    }
  }
  
  // 2 knocks moves to next song
  if(inByte==2){
    player[count].pause();
    player[count].rewind();
    count++;
    if(count>5){
      count=0;
    }
    player[count].play();
  }
  
  // 3 knocks moves to previous song
  if(inByte==3){
    player[count].pause();
    player[count].rewind();
    count--;
    if(count<0){
      count=5;
    }
    player[count].play();
  }
  
  //force sensor 1 manages volume
  if(inByte==4){//volume up
    //println(player[count].getGain());
    volume=volume+0.5;
    if(volume>20){
      volume=-30;
    }
    player[count].setGain(volume);
  }
  
  //force sensor 2 fast forwards
  if(inByte==5){
    if(started==1){
      player[count].pause();
      fast=player[count].position();
      fast=fast+500;
      player[count].play(fast);
    }
  }
  
  if(inByte==6){
    if(started==1){
      player[count].pause();
      started=0;
    }
  }
   
}

void stop(){
  /*player[0].close();
  player[1].close();
  player[2].close();
  player[3].close();
  player[4].close();
  player[5].close();
  
  minim.stop();
  super.stop();*/
}

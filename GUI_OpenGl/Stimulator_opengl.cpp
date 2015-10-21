// IN THE NAME OF ALLAH
/*
	PROJECT: STIMULATOR FOR SSVEP PROJECT WITH OPENGL
	AUTHOR: MOHAMMAD SADEGH RIAZI
*/

//----------------------------------------------------------------------- Libararies 
#include "stdafx.h"
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include <Windows.h>
#define GL_GLEXT_PROTOTYPES
#ifdef __APPLE__
#include <OpenGL/OpenGL.h>
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
#include "imageloader.h"
#include <iostream>
#include <string>
#include <fstream>
using namespace std;
//----------------------------------------------------------------------- Variables
int arr1 []={1,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1};
int arr2 []={1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1};
int arr3 []={1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1};

int arr4 []={1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1,0,0,0,1};
int arr5 []={1,1,1,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,0,0,0,1,1,1,0,0,0,1};
int arr6 []={1,1,0,0,0,1,1,1,0,0,1,1,1,0,0,0,1,1,1,0,0,1,1,1,0,0,0,1,1,1,0,0,1,1,1,0,0,0,1,1,0,0,0,1,1,1,0,0,0,1,1,0,0,0,1,1,1,0,0,1};

int arr7 []={1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0,1};
int arr8 []={1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,0,0,1};
int arr9 []={1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1};

int arr10 []={1,1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1};
int arr11 []={1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1};
int arr12 []={1,0,0,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1,1,0,0,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,1};

int * pattern [12];
int pattern_len []={60, 60 , 60,
						60, 60 , 60,
						60, 60 , 60,
						60, 60 , 60};
string total_text [12]={	"1","2","3",
								"4","5","6",
								"7","8","9",
								"Backspace","0","Call"
};
float y_margin=0.15;
float x_margin=0.25;
float up_margin=0.2;


int index [12];
int frame_num;

	
int row,col;
float heigth,width,x_corner,y_corner;
GLfloat x, y;
//----------------------------------------------------------------------- Functions
void pattern_init (void);
void print_bitmap_string(void* font, char* s)
{
   if (s && strlen(s)) {
      while (*s) {
         glutBitmapCharacter(font, *s);
         s++;
      }
   }
}

void display() {
	frame_num=floor(glutGet(GLUT_ELAPSED_TIME) *6.0/100);

	
	for (int i=0;i<12;i++){ //updating to be "white" or "black"
		index[i]=frame_num % pattern_len[i];
	}
	

	for (int i=0;i<12;i++){ //Selecting color
		if (pattern[i][index[i]]==0){
			glColor3f(0.0f, 0.0f, 0.0f); // Black	
		}
		else{
			glColor3f(1.0f, 1.0f, 1.0f); // White
		}

		row=floor (i/3.0);
		col=i % 3;


		x_corner=-1.0+( x_margin+col*(x_margin+width)   );
		y_corner=1-(up_margin+y_margin+row*(y_margin+heigth));

		glBegin(GL_QUADS);              
			glVertex2f(x_corner,y_corner);     // Define vertices in counter-clockwise (CCW) order
			glVertex2f(x_corner,y_corner-heigth);     //  so that the normal (front-face) is facing you
			glVertex2f(x_corner+width,y_corner-heigth);
			glVertex2f(x_corner+width,y_corner);
		glEnd();

		//-------------Draw text
		glColor4f(0.0, 1.0, 0.0, 0.0);
		x = x_corner+width/2.0;
		y = y_corner-heigth/2.0;
		glRasterPos2f(x-total_text[i].length()/50.0*width, y);
		char text [10];
		strcpy(text,total_text[i].c_str());
		print_bitmap_string(GLUT_BITMAP_TIMES_ROMAN_24, text);	
	}

	//send to dispaly on monitor
	glutSwapBuffers();


	//-----------------Updating total numbers
	fstream myfile ("ex_data.txt",ios::in);
	int size=30;
	char * mem_block;
	mem_block = new char [size];
	myfile.read(mem_block,size);
	string new_str (mem_block,size);
	
	fstream myfile_status ("stauts.txt",ios::in);
	int size_status=30;
	char * mem_block_status;
	mem_block_status = new char [size_status];
	myfile.read(mem_block_status,size);
	string new_str_status (mem_block_status,size);

	glColor3f(0.0f, 0.0f, 1.0f);
	glBegin(GL_QUADS);              
		glVertex2f(-0.3,0.95);     // Define vertices in counter-clockwise (CCW) order
		glVertex2f(-0.3,0.8);     //  so that the normal (front-face) is facing you
		glVertex2f(0.3,0.8);
		glVertex2f(0.3,0.95);
	glEnd();

	if (new_str[0]=='C'){
		if(     (frame_num/30)      %2    ==0    ){
			glColor3f(1.0f, 1.0f, 0.0f);//yellow for Calling
		}
		else{
			glColor3f(1.0f, 0.0f, 0.0f);//yellow for Calling
		}
		
		glRasterPos2f(-0.14,0.87);
	}
	else{
		glColor3f(0.0f, 1.0f, 1.0f);
		glRasterPos2f(-0.1,0.87);
	}
	char number [40];
	strcpy(number,new_str.c_str());
	print_bitmap_string(GLUT_BITMAP_TIMES_ROMAN_24, number);	//show the number

	//---------------------------
	
}


void initGL() {
   // Set "clearing" or background color
   glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // Black and opaque
}
 
/* Called back when there is no other event to be handled */
void idle() {
   glutPostRedisplay();   // Post a re-paint request to activate display()
}

//----------------------------------------------------------------------- Main ********************************************
int main(int argc, char** argv) {
	heigth=(2.0-(up_margin+5*y_margin))/4.0;
	width=(2.0-4*x_margin)/3.0;
	pattern_init();
	glutInit(&argc, argv);
	glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGB);	
	glutInitWindowSize(1280, 800);   // Set the window's initial width & height
	glutInitWindowPosition(0, 0); // Position the window's initial top-left corner
	glutCreateWindow ("Stimulator of SSVEP_based BCI by M.S. Riazi V1.2");
	glutFullScreen(); 
	glutDisplayFunc(display);
	glutIdleFunc(idle); 
	initGL();   
   glutMainLoop();                 // Enter the event-processing loop
   return 0;
}

//----------------------------------------------------------------------- Functions 2
void pattern_init (void){
	pattern[0]=arr1;
	pattern[1]=arr2;
	pattern[2]=arr3;

	pattern[3]=arr4;
	pattern[4]=arr5;
	pattern[5]=arr6;

	pattern[6]=arr7;
	pattern[7]=arr8;
	pattern[8]=arr9;

	pattern[9]=arr10;
	pattern[10]=arr11;
	pattern[11]=arr12;	
}
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

#define SIZEX 128
#define SIZEY 128
#define HEADER(X,Y) "P6\n" #X " " #Y " 255\n"
#define HEADERSTR (HEADER(128,128))
#define HEADERSIZE (sizeof(HEADERSTR)-1)
#define BODYSIZE (SIZEX*SIZEY)

#define THREATHOLD 0

//êFÇêîî{Ç…ÇµÇƒã≠í≤ï\é¶
#define DIFFCOLORMUL 100

struct rgb{
	int r;
	int g;
	int b;
};
int readppm(FILE *fp,struct rgb body[SIZEY][SIZEX],char* filename){
	int x,y;
	char header[HEADERSIZE+1];
	struct rgb c;
	
	if(fread(header,HEADERSIZE,1,fp)<1){
		fprintf(stderr,"ERROR:%s:Not enough header.\n",filename);
		return -1;
	}
	header[HEADERSIZE]='\0';
	if(strcmp(header,HEADERSTR)!=0){
		fprintf(stderr,"ERROR:%s:Header does not match.\n",filename);
		fprintf(stderr,"ERROR:%s:Header must be %s.\n",filename,HEADERSTR);
		return -1;
	}
	for(y=0;y<SIZEY;y++){
		for(x=0;x<SIZEX;x++){
			if(((c.r=fgetc(fp))==EOF)||((c.g=fgetc(fp))==EOF)||((c.b=fgetc(fp))==EOF)){
				fprintf(stderr,"ERROR:%s:Not enough data at (%d,%d) (%d).\n",filename,x,y,y*SIZEX+x);
				return -1;
			}
			body[y][x]=c;
		}
	}
	return 0;
}
int writeppm(FILE *fp,struct rgb body[SIZEY][SIZEX]){
	int x,y;
	struct rgb c;
	
	fprintf(fp,"%s",HEADERSTR);
	for(y=0;y<SIZEY;y++){
		for(x=0;x<SIZEX;x++){
			c=body[y][x];
			fprintf(fp,"%c%c%c",c.r,c.g,c.b);
		}
	}
	return 0;
}

int main(int argc,char* argv[]){
	int x,y;
	FILE *fpr,*fpt;
	FILE *fpo;
	struct rgb br[SIZEY][SIZEX];
	struct rgb bt[SIZEY][SIZEX];
	struct rgb bo[SIZEY][SIZEX];
	struct rgb c;
	
	if(argc!=4){
		fprintf(stderr,"USAGE:%s originalfile testfile difffile\n",argv[0]);
		return -1;
	}
	
	if((fpr=fopen(argv[1],"rb"))==NULL){
		fprintf(stderr,"Cannot open %s.\n",argv[1]);
		return -1;
	}
	if(readppm(fpr,br,argv[1])<0){
		return -1;
		fclose(fpr);
	}
	fclose(fpr);

	if((fpt=fopen(argv[2],"rb"))==NULL){
		fprintf(stderr,"Cannot open %s.\n",argv[2]);
		return -1;
	}
	if(readppm(fpt,bt,argv[2])<0){
		return -1;
		fclose(fpt);
	}
	fclose(fpt);
	
	for(y=0;y<SIZEY;y++){
		for(x=0;x<SIZEX;x++){
			c.r=(unsigned char)abs(((int)br[y][x].r)-((int)bt[y][x].r));
			if(c.r>THREATHOLD){
				printf("DIFF:red value over the threathold at (%d,%d) (%d,%d,%d) and (%d,%d,%d)\n",x,y,br[y][x].r,br[y][x].g,br[y][x].b,bt[y][x].r,bt[y][x].g,bt[y][x].b);
			}
			c.r=min(DIFFCOLORMUL*c.r,255);
			c.g=(unsigned char)abs(((int)br[y][x].g)-((int)bt[y][x].g));
			if(c.r>THREATHOLD){
				printf("DIFF:green value over the threathold at (%d,%d) (%d,%d,%d) and (%d,%d,%d)\n",x,y,br[y][x].r,br[y][x].g,br[y][x].b,bt[y][x].r,bt[y][x].g,bt[y][x].b);
			}
			c.g=min(DIFFCOLORMUL*c.g,255);
			c.b=(unsigned char)abs(((int)br[y][x].b)-((int)bt[y][x].b));
			if(c.r>THREATHOLD){
				printf("DIFF:blue value over the threathold at (%d,%d) (%d,%d,%d) and (%d,%d,%d)\n",x,y,br[y][x].r,br[y][x].g,br[y][x].b,bt[y][x].r,bt[y][x].g,bt[y][x].b);
			}
			c.g=min(DIFFCOLORMUL*c.g,255);
			bo[y][x]=c;
		}
	}

	if((fpo=fopen(argv[3],"wb"))==NULL){
		fprintf(stderr,"Cannot open %s.\n",argv[3]);
		return -1;
	}
	if(writeppm(fpo,bo)<-1){
		return -1;
		fclose(fpo);
	}
	fclose(fpo);
	return 0;
}

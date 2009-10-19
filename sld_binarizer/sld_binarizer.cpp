// cserver.cc ÇÃÉRÅ[ÉhÇÇ®éÿÇËÇµÇ‹ÇµÇΩ

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <memory.h>
#include <string.h>

#include <time.h>

#define N_ELEMS(A) (sizeof(A)/sizeof((A)[0]))

static void error_exit(const char* fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  exit(1);
}

//*****************************************************************************
// SLD Reader

// convert the input SLD text file into a binary format

static const unsigned MAX_N_WORDS = 4096;

union fi_union {
  int i;
  float f;
};

// the binary image of the input SLD data
static fi_union sld_words[MAX_N_WORDS];
static unsigned sld_n_words = 0;

//-----------------------------------------------------------------------------
// read a float in the SLD file and append it to the array sld_words.
// fp : input SLD file stream
// RETURN value : the float read from the file
static float read_float(FILE* fp)
{
  float f;

  if(sld_n_words >= MAX_N_WORDS)
    error_exit("read_float : too many sld words.\n");

  if(fscanf(fp, "%f", &f) != 1)
    error_exit("failed to read a float\n");

  return (sld_words[sld_n_words++].f = f);
}

//-----------------------------------------------------------------------------
// read an integer in the SLD file and append it to the array sld_words.
// fp : input SLD file stream
// RETURN value : the integer read from the file
static int read_int(FILE* fp)
{
  int i;
  if(sld_n_words >= MAX_N_WORDS)
    error_exit("read_int : too many sld words.\n");

  if(fscanf(fp, "%d", &i) != 1)
    error_exit("failed to read an int\n");
  
  return (sld_words[sld_n_words++].i = i);
}

//-----------------------------------------------------------------------------
// read a 3D float vector and append it to the array sld_words.
// fp : input SLD file stream
static void read_vec3(FILE* fp)
{
  read_float(fp);
  read_float(fp);
  read_float(fp);
}

//-----------------------------------------------------------------------------
// read the scene environments
// fp : input SLD file stream
static void read_sld_env(FILE* fp)
{
  // screen pos
  read_vec3(fp);
  // screen rotation
  read_float(fp);  read_float(fp); 
  // n_lights : Actually, it should be an int value !
  read_float(fp);
  // light rotation
  read_float(fp);  read_float(fp);
  // beam  
  read_float(fp);
}

//-----------------------------------------------------------------------------
// read all the objects
// fp : input SLD file stream
static void read_objects(FILE* fp)
{

  while (read_int(fp) != -1) {  // texture : -1 -> end
    // form
    read_int(fp);
    // refltype
    read_int(fp);
    // isrot_p
    int is_rot = read_int(fp);
    // abc
    read_vec3(fp);
    // xyz
    read_vec3(fp);
    // is_invert
    read_float(fp);
    // refl_param
    read_float(fp); read_float(fp);
    // color
    read_vec3(fp);
    // rot
    if(is_rot){
      read_vec3(fp);
    }
  }
}

//-----------------------------------------------------------------------------
// read the AND-network
// fp : input SLD file stream
static void read_and_network(FILE* fp)
{
  while(read_int(fp) != -1){
    while(read_int(fp) != -1);
  }
}

//-----------------------------------------------------------------------------
// read the OR-network
// fp : input SLD file stream
static void read_or_network(FILE* fp)
{
  while(read_int(fp) != -1){
    while(read_int(fp) != -1);
  }
}

//-----------------------------------------------------------------------------
// read the SLD file
// fp : input SLD file stream
static void read_sld(FILE* fp, bool conv_to_big_endian)
{
  read_sld_env(fp);
  read_objects(fp);
  read_and_network(fp);
  read_or_network(fp);
  if(conv_to_big_endian){
    unsigned u;
    for(u = 0; u < sld_n_words; u++){
      int i = sld_words[u].i;
      sld_words[u].i = 
        ((i & 0xff) << 24) | ((i & 0xff00) << 8) |
          ((i >> 8) & 0xff00) | ((i >> 24) & 0xff);
    }
  }
}

//*****************************************************************************
// Each step of the server

//-----------------------------------------------------------------------------
// read the SLD file and convert into a binary format.
// sld_file_name : name of the SLD data file
static void load_sld_file(const char* sld_file_name, bool conv_to_big_endian)
{
  FILE* fp = sld_file_name ? fopen(sld_file_name, "rb") : stdin;
  if(fp == NULL)
    error_exit("cannot open SLD file %s\n", sld_file_name);
  read_sld(fp, conv_to_big_endian);

  fclose(fp);
}

//-----------------------------------------------------------------------------
// send the SLD data in a binary format.
static void write_sldb_data(FILE *out) {
  unsigned n_write = sld_n_words * sizeof(sld_words[0]);
  const char *p = (const char*)sld_words;
  for (int i = 0; i < (int)n_write; i++) {
    fputc(p[i], out);
  }
  fprintf(stderr, "\n\tdone.\n");
}


static const char usage[] =
" usage : %s [options] [input SLD file(default stdin)]\n"
" options :\n"
"\t-o filename   : specify output SLDB file name(default stdout)\n"
"\t-b            : output SLDB data in big-endian format.\n"
"\t-h            : print this help.\n";

//-----------------------------------------------------------------------------
// main
int main(int argc, char* argv[])
{
  int i;
  char* sld_file_name = NULL;
  char* sldb_file_name = NULL;
  bool conv_to_big_endian = false;
  
  // parse args
  for(i = 1; i < argc; i++){
    if(!strcmp(argv[i], "-o")){
      if(++i >= argc)
        error_exit(usage, argv[0]);
      sldb_file_name = argv[i];

    } else if(!strcmp(argv[i], "-b")){
      conv_to_big_endian = true;

    } else if(!strcmp(argv[i], "-h")){
      fprintf(stderr, usage, argv[0]);
      return 0;

    } else if(i+1 == argc){
      sld_file_name = argv[i];

    } else {
      error_exit(usage, argv[0]);
    }
  }

  // open the output PPM file
  FILE* out = sldb_file_name ? fopen(sldb_file_name, "wb") : stdout;
  if(!out)
    error_exit("cannot open SLDB output file %s\n", sldb_file_name);

  // load SLD data
  load_sld_file(sld_file_name, conv_to_big_endian);

  // write SLDB data
  write_sldb_data(out);

  return 0;
}


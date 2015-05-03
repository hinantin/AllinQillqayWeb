#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <getopt.h>
#include <cstring>
#include "hunspell.h"

#define LINE_LIMIT 262144

char *usagestring = "Usage: tcpServer <affix file path> <dictionary file path>\n";
char *helpstring = "Applies hunspell spellcheck to words from stdin to a hunspell affix and dictionary read from a file\nOptions:\n-h\t\tprint help\n-l med_limit\tset maximum number of suggestions (default is 5)\n-c cutoff\tset maximum levenshtein distance for suggestions (default is 15)";

static FILE *INFILE;

int main(int argc, char *argv[]) {
  int opt = 1;
  char *affpath, *dpath, **slist;
  int list_size, i;
  char line[LINE_LIMIT], *result;
  
  INFILE = stdin;
  /* get analyzer binary */
  affpath = argv[optind];
  dpath = argv[optind + 1];
  char const word[256] = "ñawi";
  Hunhandle *pHunspell = Hunspell_create(affpath, dpath);
  printf("%s\n\n", Hunspell_get_dic_encoding(pHunspell));
  
  while (fgets(line, LINE_LIMIT, INFILE) != NULL) {
    line[strcspn(line, "\n")] = '\0'; /* chomp */
    if (Hunspell_spell(pHunspell, line)) {
      printf("%s\n", line);
    }
    else {
      printf("+?\n");
      list_size = Hunspell_suggest(pHunspell, &slist, line);
      if (list_size == 0) {
        printf("???\n");
      }
      else {
        for (i = 0; i < list_size; i++) {
          printf("\"%s\",", slist[i]);
        }
        printf("\n");
      }
    }
  }
  
  if (pHunspell != NULL) {
    Hunspell_destroy(pHunspell);
  }
  exit(0);
}

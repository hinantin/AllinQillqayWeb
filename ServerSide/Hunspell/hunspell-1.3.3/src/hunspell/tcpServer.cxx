#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <time.h> 
#include <limits.h>
#include <getopt.h>
#include <cstring>
#include "hunspell.h"

#define LINE_LIMIT 262144
#define FLOOKUP_PORT 8889

char *usagestring = "Usage: tcpServer <affix file path> <dictionary file path>\n";
char *helpstring = "Applies hunspell spellcheck to words from stdin to a hunspell affix and dictionary read from a file\n"
"Options:\n-h\t\tprint help\n"
"-l med_limit\tset maximum number of suggestions (default is 5)\n"
"-c cutoff\tset maximum levenshtein distance for suggestions (default is 15)";

static int port_number = FLOOKUP_PORT;
struct sockaddr_in serv_addr;
static FILE *INFILE;
char *corr;

char* concat(char *s1, char *s2);

int main(int argc, char *argv[]) {
  int opt = 1;
  char *affpath, *dpath, **slist;
  int list_size, i;
  char line[LINE_LIMIT], *result;
  
  INFILE = stdin;
  
  while ((opt = getopt(argc, argv, "P:h")) != -1) {
      switch (opt) {
          case 'h':
              printf("%s%s\n", usagestring, helpstring);
              exit(0);
          case 'P':
              port_number = atoi(optarg);
              break;
          default:
              fprintf(stderr, "%s", usagestring);
              exit(EXIT_FAILURE);
      }
  }

  /* get analyzer binary */
  affpath = argv[optind];
  dpath = argv[optind + 1];
  Hunhandle *pHunspell = Hunspell_create(affpath, dpath);
  printf("%s\n\n", Hunspell_get_dic_encoding(pHunspell));
  

  //########################################//
  int listenfd = 0, connfd = 0;
  int byte_count;
  char sendBuff[1025];

  listenfd = socket(AF_INET, SOCK_STREAM, 0);
  memset(&serv_addr, '0', sizeof (serv_addr));
  memset(sendBuff, '0', sizeof (sendBuff));
  
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  serv_addr.sin_port = htons(port_number);

  if (bind(listenfd, (struct sockaddr*) &serv_addr, sizeof (serv_addr)) < 0) {
    perror("ERROR on binding");
    exit(1);
  } else {
    printf("started server on port %d\n", port_number);
  }

  listen(listenfd, 10);
  /*
  while (fgets(line, LINE_LIMIT, INFILE) != NULL) {
    line[strcspn(line, "\n")] = '\0'; 
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
  */
    while (1) {
        connfd = accept(listenfd, (struct sockaddr*) NULL, NULL);
        // fork child
        int pid = fork();
        if (pid < 0) {
            perror("ERROR could not fork");
            exit(1);
        }
        if (pid == 0) {
            /* This is the client process */
            close(listenfd);
            do {
                byte_count = recv(connfd, sendBuff, 1024, 0);
                if (byte_count < 0) {
                    perror("ERROR reading from socket");
                    exit(1);
                }
                sendBuff[byte_count] = '\0';
                char *line = concat(sendBuff, "");
                if (strlen(line) > 0) {
                corr = "|correct:";
                char *outstr = "";
                if (Hunspell_spell(pHunspell, line)) {
                  corr = concat(corr, line);
                }
                else {
                  list_size = Hunspell_suggest(pHunspell, &slist, line);
                  if (list_size == 0) {
                    outstr = "";
                  }
                  else {
                    for (i = 0; i < list_size; i++) {
                      char *tmp = concat(slist[i], ",");
                      outstr = concat(outstr, tmp);
                    }
                  }
                }
                outstr = concat("incorrect:", outstr);
                char *result = concat(outstr, corr);
                write(connfd, result, strlen(result));
                }
            } while (byte_count > 0);
            exit(0);
        } else {
            close(connfd);
        }
    }

  
  if (pHunspell != NULL) {
    Hunspell_destroy(pHunspell);
  }

  close(connfd);
  sleep(1);
  exit(0);
}

char* concat(char *s1, char *s2) {

    size_t len1 = strlen(s1);
    size_t len2 = strlen(s2);
    char *result = (char*)malloc(len1 + len2 + 1); //+1 for the zero-terminator
    memcpy(result, s1, len1);
    memcpy(result + len1, s2, len2 + 1); //+1 to copy the null-terminator
    return result;
}

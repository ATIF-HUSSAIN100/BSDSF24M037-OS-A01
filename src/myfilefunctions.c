// File: src/myfilefunctions.c
#include "myfilefunctions.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int wordCount(FILE* file, int* lines, int* words, int* chars) {
    if (file == NULL || lines == NULL || words == NULL || chars == NULL) {
        return -1;
    }
    
    *lines = 0;
    *words = 0;
    *chars = 0;
    
    int c;
    int in_word = 0;
    
    while ((c = fgetc(file)) != EOF) {
        (*chars)++;
        
        if (c == '\n') {
            (*lines)++;
        }
        
        if (isspace(c)) {
            in_word = 0;
        } else {
            if (!in_word) {
                (*words)++;
                in_word = 1;
            }
        }
    }
    
    return 0;
}

int mygrep(FILE* fp, const char* search_str, char** matches) {
    if (fp == NULL || search_str == NULL || matches == NULL) {
        return -1;
    }
    
    char buffer[1024];
    int count = 0;
    int max_matches = 100;
    
    while (fgets(buffer, sizeof(buffer), fp) != NULL && count < max_matches) {
        if (strstr(buffer, search_str) != NULL) {
            matches[count] = (char*)malloc(strlen(buffer) + 1);
            if (matches[count] == NULL) {
                return -1;
            }
            strcpy(matches[count], buffer);
            count++;
        }
    }
    
    return count;
}

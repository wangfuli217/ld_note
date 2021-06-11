/* genindex.cc */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <string>
#include <list>
#include <vector>
#include <map>
using namespace std;

/* make the program wait, so it is possible to inspect process for memory use */
void wait_for_input(const char *prefix) {
    char c;
    fprintf(stderr, "%s hit return to continue\n", prefix); fflush(stderr);
    c = getchar();
}

// word index data structure: word as key, list of integers 
// each integer stores the line number where the word occurs
typedef map<string,list<int>,less<string> > WordIndexType;

// wrapper class, stores one index per text file
class FileIndexType
{
public:
    FileIndexType();
    ~FileIndexType();
    int scan_file(char *fname);
    int add_to_index(string &key, int l);
    void print_index();
    int verify_index();
    void clear();
    void clear_lines();
    int print_memory_stats();
protected:
    string filename;
    int filesize;
    WordIndexType wordindex;
    vector<string> lines;
};

// constructor
FileIndexType::FileIndexType()
{}

// destructor
FileIndexType::~FileIndexType() {
    clear();
}

// clear the index 
void FileIndexType::clear() {
    filename.clear();
    filesize = 0;
    wordindex.clear();
    clear_lines();
}

// clear the lines buffer
void FileIndexType::clear_lines() {
    lines.clear();
}

// generate a report of memory usage
int FileIndexType::print_memory_stats() {
    unsigned i;
    int mem_filename = sizeof(string) + filename.size();
    int mem_wordindex = 0;
    int mem_lines = 0;
    int mem_total = 0;

// compute size of wordindex data structure
// Note: very rough approximation, measures the payload, not
// the internal search structure of map.
    WordIndexType::const_iterator it;
    list<int>::const_iterator wt;
    for(it = wordindex.begin(); it != wordindex.end(); it++) {
        mem_wordindex += it->first.size();        // add size of word key
        for(wt = it->second.begin(); wt != it->second.end(); wt++)
// double-linked list element size is at least 2 pointers plus the content
            mem_wordindex += sizeof(int) + 2 * sizeof(void*);
    }

// compute size of lines data structure payload
     for (i=0; i < lines.size(); i++)
        mem_lines += lines[i].size();

    mem_total = mem_filename + mem_wordindex + mem_lines;

    fprintf(stderr, "-- memory size for index of file '%s' size of file=%d:\n",
        filename.c_str(), filesize);
    fprintf(stderr, "--     filename=%d wordindex=%d lines=%d total=%d\n",
        mem_filename, mem_wordindex, mem_lines, mem_total);
    fflush(stderr);
    return mem_total;
}

// add a (word, line) pair to the index
int FileIndexType::add_to_index(string &key, int l) {
    if(key.size() == 0)
        return 0;
    wordindex[key].push_back(l); 
    return 0;
}

// open file, break text into words, add words to index, close file
int FileIndexType::scan_file(char *fname) {
    filename = fname;
    filesize = 0;
    FILE *fp = 0;
    int c = 0;
    string newword = "";
    int current_line = 1;  /* start counting lines at value 1 */
    string buffer;
 
    if(NULL == (fp = fopen(filename.c_str(), "r"))) {
        fprintf(stderr, "-- error: cannot read file '%s'\n", filename.c_str());
        return 1;
    }

    while(1) {   // very simple tokenizer to break text into words
        c = getc(fp);

        if(c == EOF || c == '\n') { 
             add_to_index(newword, current_line);
             newword = "";
             current_line++;
             lines.push_back(buffer);
#ifdef FIX_LINES
             buffer = "";
#endif
             if(c == EOF)
                 break;
        }
        else if(c == ' ' || c == '\t' || c == '\r') {
             add_to_index(newword, current_line);
             newword = "";
             if(c != '\r')
                 buffer = buffer + (char) c;
        }         
        else {
             newword = newword + (char) c;
             buffer = buffer + (char) c;
        }
        filesize++;
    }
    fclose(fp);
    return 0;
}

// output of the program: a word index
void FileIndexType::print_index() {
    WordIndexType::const_iterator it;
    list<int>::const_iterator wt;
    printf("index of file '%s'\n", filename.c_str());
    for(it = wordindex.begin(); it != wordindex.end(); it++) {
        printf("'%s'", it->first.c_str());
        for(wt = it->second.begin(); wt != it->second.end(); wt++)
            printf(" %d", (*wt));
        printf("\n");
    }
    fflush(stdout);
}

// verification code: cross-check generated index
int FileIndexType::verify_index() {
    int result = 0;
    WordIndexType::const_iterator it;
    list<int>::const_iterator wt;
    string w;
    int i;
    for(it = wordindex.begin(); it != wordindex.end(); it++)
    {
        w = it->first;
        for(wt = it->second.begin(); wt != it->second.end(); wt++) {
            i = (*wt);
            if(string::npos == lines[i-1].find(w))
                return 1;
        }
    }
    return result;
}

/* program entry point */
int main(int argc, char **argv) {
    const char *usage = "-- usage: genindex filename [filename...]\n";
    if(argc < 2) {
        fprintf(stderr, usage);
            return 1;
    }
    vector<FileIndexType> fileindex(argc-1);
    int result = 0;
    int total = 0;
    int i;

// for each file, compute an index
    for(i = 0; i<argc-1; i++) {
        result = fileindex[i].scan_file(argv[i+1]);
        if(result)
            return result;  // something went wrong with reading the file
        result = fileindex[i].verify_index();
        if(result) {    
            fprintf(stderr, "-- internal error: verification of index failed.\n"); 
            return result;
        }
#ifdef CLEAR_INDEX
        fileindex[i].print_index();
        fileindex[i].clear();
        total += fileindex[i].print_memory_stats();
#endif
#ifdef PAUSE_INDEX
        wait_for_input("-- done generating index: ");
#endif
    }

#ifndef CLEAR_INDEX
// for each file, output index
    for(i=0; i<argc-1; i++) {
        fileindex[i].print_index();
        total += fileindex[i].print_memory_stats();
    }
#endif
    fprintf(stderr, "-- memory size for all data structures: %d bytes\n", total);
    return result;
}

SEARCH = search
SEARCHOBJS = tokenizers/parse_tree.o index/document.o index/ram_index.o tokenizers/pos_tree_tokenizer.o \
    tokenizers/level_tree_tokenizer.o tokenizers/ngram_tokenizer.o io/textfile.o io/parser.o \
    index/lexicon.o index/inverted_index.o io/compressed_file_reader.o io/compressed_file_writer.o \
    index/postings.o libstemmer/libstemmer.o

TESTER = tester
TESTER_OBJS = io/compressed_file_reader.o io/compressed_file_writer.o io/textfile.o \
    io/parser.o index/lexicon.o index/postings.o

CC = g++ -std=c++0x -fopenmp -I.
CCOPTS = -g -O0
#CCOPTS = -O3
LINKER = g++ -std=c++0x -fopenmp -I.

CLEANDIRS = tokenizers test io index util

all: $(SEARCH) $(TESTER)

$(SEARCH): $(SEARCHOBJS) main.cpp util/invertible_map.h util/invertible_map.cpp
	$(LINKER) main.cpp -o $@ $(SEARCHOBJS)

$(TESTER): $(TESTER_OBJS) test/tester.cpp util/invertible_map.h util/invertible_map.cpp
	$(LINKER) test/tester.cpp -o $@ $(TESTER_OBJS)

%.o : %.cpp $(wildcard *.h)
	$(CC) $(CCOPTS) -c $(@:.o=.cpp) -o $@

clean:
	for dir in $(CLEANDIRS) ; do rm -rf $$dir/*.o ; done
	rm -f $(SEARCH) $(TESTER)

tidy: clean
	rm -rf ./doc
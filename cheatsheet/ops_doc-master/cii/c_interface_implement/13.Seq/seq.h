#ifndef SEQ_H_
#define SEQ_H_

typedef struct Seq_t *Seq;

extern Seq 	Seq_new(int hint);
extern Seq 	Seq_seq(void *x, ...);
extern void Seq_free(Seq *seq);
extern int 	Seq_length(Seq seq);
extern void Seq_map(Seq seq,void (*apply)(void *));
extern void *Seq_get(Seq seq, int i);
extern void *Seq_put(Seq seq, int i, void *x);
extern void *Seq_addlo(Seq seq, void *x);
extern void *Seq_addhi(Seq seq, void *x);
extern void *Seq_remlo(Seq seq);
extern void *Seq_remhi(Seq seq);

#endif


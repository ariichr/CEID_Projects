//Αποκτήθηκε από: https://github.com/ και http://en.literateprograms.org/Hash_table_(C)?oldid=19638
/*
	Η συγκεκριμένη βιβλιοθήκη έχει αναπτυχθεί για τις ανάγκες της εργάσιας αφού δηλώσαμε τις νέες συναρτήσεις:
	(hashtable_search, hashtable_get_value) στο header file <hashtbl.h>
	
    * Η <hashtable_search> δέχεται ως πάραμετρους τα παρακάτω, ενώ ο σκοπός της είναι η αναζήτηση μέσα στο hashtable με χρήση nodes και hashing(hashfunc)
	1) το hashtable στο οποίο θέλουμε να κάνουμε την αναζήτηση,
	2) το key(κλειδί) που μετατρέπεται σε string ή number χάρη στο flex, το οποίο ψάχνουμε να ταιριάξουμε,
	3) το scope(εμβέλεια) του συγκεκριμένου δεδομένου(πλεον) με σκοπό την ανίχνευση επιτυχής ή ανεπιτυχής δήλωσης

	* H <hashtable_get_value> έχει τις ίδιες παραμέτρους ενώ ο σκοπός της είναι να επιστρέφει το δεδομένο που αντιστοιχεί στο εκάστοτε κλειδι
	(χρησιμοποιείται στο πρόγραμμά μας σε συνδυασμό με την typedef_id_match, στην γραμματική του bison.y για την επιτυχή ή ανεπιτυχή δομή του TYPEDEF STRUCT)
	
	*/

#include "hashtbl.h"
#include "settings.h"

#include<string.h>
#include<stdio.h>

static char *mystrdup(const char *s)
{
	char *b;
	if(!(b=malloc(strlen(s)+1))) return NULL;
	strcpy(b, s);
	return b;
}

static hash_size def_hashfunc(const char *key)
{
	hash_size hash=0;
	
	while(*key) hash+=(unsigned char)*key++;

	return hash;
}

HASHTBL *hashtbl_create(hash_size size, hash_size (*hashfunc)(const char *))
{
	HASHTBL *hashtbl;
	if(!(hashtbl=malloc(sizeof(HASHTBL)))) return NULL;

	if(!(hashtbl->nodes=calloc(size, sizeof(struct hashnode_s*)))) {
		free(hashtbl);
		return NULL;
	}

	hashtbl->size=size;

	if(hashfunc) hashtbl->hashfunc=hashfunc;
	else hashtbl->hashfunc=def_hashfunc;

	return hashtbl;
}
int hashtbl_search(HASHTBL *hashtbl, const char *key,int scope)
{
	struct hashnode_s *node;
	hash_size hash=hashtbl->hashfunc(key)%hashtbl->size;
	node=hashtbl->nodes[hash];
	while(node) {
		if((strcmp(node->key, key) == 0) && (node->scope <= scope))
			return 0;
		else if ((!strcmp(node->key, key)) && (node->scope > scope)){
			fprintf(stderr,"\nThere is an error|Token: %s is not declared properly\n", key);
			exit(1);
		}
	
		node=node->next;
	}
	fprintf(stderr,"\nThere is an error|Token: %s was not found\n", key);
	exit(1);
}
char *hashtbl_get_value(HASHTBL *hashtbl, const char *key, int scope) {

	struct hashnode_s *node;
	hash_size hash=hashtbl->hashfunc(key)%hashtbl->size;
	node=hashtbl->nodes[hash];
	while(node) {
		if(node->scope == scope) 
        	if(HASHTBL_DEBUG) {
				return node->key; 
			}
		node=node->next;
	}
}


void hashtbl_destroy(HASHTBL *hashtbl) 
{
	hash_size n;
	struct hashnode_s *node, *oldnode;
	
	for(n=0; n<hashtbl->size; ++n) {
		node=hashtbl->nodes[n];
		while(node) {
			free(node->key);
			oldnode=node;
			node=node->next;
			free(oldnode);
		}
	}
	free(hashtbl->nodes);
	free(hashtbl);
}

int hashtbl_insert(HASHTBL *hashtbl, const char *key, void *data ,int scope)
{
	struct hashnode_s *node;
	hash_size hash=hashtbl->hashfunc(key)%hashtbl->size;

    if(HASHTBL_DEBUG && HASHTBL_SHOW_INSERT)
        printf("HASHTBL_INSERT(): KEY = %s, HASH = %ld,  \tDATA = %s, SCOPE = %d\n", key, hash, (char*)data, scope);

	node=hashtbl->nodes[hash];
	while(node) {
		if(!strcmp(node->key, key) && (node->scope == scope)) {
			node->data=data;
			return 0;
		}
		node=node->next;
	}

	if(!(node=malloc(sizeof(struct hashnode_s)))) return -1;
	if(!(node->key=mystrdup(key))) {
		free(node);
		return -1;
	}
	node->data=data;
	node->scope = scope;
	node->next=hashtbl->nodes[hash];
	hashtbl->nodes[hash]=node;

	return 0;
}

int hashtbl_remove(HASHTBL *hashtbl, const char *key,int scope)
{
	struct hashnode_s *node, *prevnode=NULL;
	hash_size hash=hashtbl->hashfunc(key)%hashtbl->size;

	node=hashtbl->nodes[hash];
	while(node) {
		if((!strcmp(node->key, key)) && (node->scope == scope)) {
			free(node->key);
			if(prevnode) prevnode->next=node->next;
			else hashtbl->nodes[hash]=node->next;
			free(node);
			return 0;
		}
		prevnode=node;
		node=node->next;
	}

	return -1;
}


%{
//7-SAMPLE PARTS-OF-SPEECH RECOGNISER
%}
%%
[\t ]+ ;
is|am|were|was|be|being|been|do|does|did|will|would|should|can|could|has|have|had|go printf("%s : is a verb\n\n",yytext);

very|simply|gently|quietly|calmly|angrily printf("%s : is adverb\n\n",yytext);

to|from|behind|above|below|between printf("%s : is preposition\n\n",yytext);

if|then|and|but|or printf("%s : is conjuction\n\n",yytext);

their|my|your|his|her|its printf("%s : is adjective\n\n",yytext);

I|you|he|she|we|they printf("%s : is pronoun\n\n",yytext);

[a-zA-Z]+ printf("%s : is not recognised\n\n",yytext);

.|\n ECHO;
%%


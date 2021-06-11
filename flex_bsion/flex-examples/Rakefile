task :quotes do
  sh 'flex quotes.l ; gcc lex.yy.c -lfl ; ./a.out'
end

task :comments do
  sh 'flex comments.l ; gcc lex.yy.c ; ./a.out < hello.c'
end

task :ststring do
  puts 'Introduzca una cadena C con simbolos de escape \n, \t, etc.'
  sh 'flex ststring.l ; gcc lex.yy.c ; ./a.out'
end

task :clean do
  sh 'rm a.out lex.yy.l'
end

guard :shell do
    watch(%r{^lex_man.L$}) do
        system('lex lex_man.L')
    end

    watch(%r{^lex.yy.c$}) do
        system('gcc lex.yy.c -o lexer -ll')
    end
end


:- encoding(utf8).
% Irina Cojocari 117890
:- style_check(-discontiguous).
:- set_prolog_flag(answer_write_options,[max_depth(0)]). 
:- ['codigoAuxiliar.pl']. 
:- ['bd_estudantes.pl']. 
:- ['listas_palavras.pl']. 
:- ['jogar.pl'].

/* -----Inicio da parte um do projeto-----*/

%Calcula a média dos valores em ListaValores, com 2 casas decimais
media([], 0) :- !.
media(ListaValores, Media) :- 
    sum_list(ListaValores, Soma),
    length(ListaValores, Contagem),
    arredonda(Soma/Contagem, Media).


%Se o estudante tem entre IdadeMin e IdadeMax, obtem a sua nota
filtraIdade(IdadeMin, IdadeMax, Nota, Id) :- 
    estudante(Id, Idade, _), 
    Idade =< IdadeMax,
    Idade > IdadeMin,
    exame(Id, Nota).

%Calcula a media das notas dos alunos de um determinado intervalo de idades
mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota, filtraIdade(IdadeMin, IdadeMax, Nota, _), ListaNotas), 
    media(ListaNotas, Media).

%Se o aluno é do GeneroPretendido, obtem a sua FrequenciaAulas
filtraGenero(GeneroPretendido, FrequenciaAulas, Id) :-
    estudante(Id, _, Genero),
    Genero == GeneroPretendido,
    atividade(Id, _, _, FrequenciaAulas).


%Calcula a media de vezes que os alunos de um dado genero frequentam as aulas
freqPorGenero(Genero, MediaFreq) :-
    findall(FrequenciaAulas, filtraGenero(Genero, FrequenciaAulas, _), ListaFreq),
    media(ListaFreq, MediaFreq).


%Averigua se um dado aluno está abaixo dos limites considerados saudaveis
filtraSaude(Id, HorasSono, Exercicio, SaudeMental) :-
    estudante(Id, _, _),
    saude(Id, Sono, Alimentacao, ExercicioAluno, SaudeMentalAluno),
    Alimentacao == 'fraca',
    Sono < HorasSono,
    ExercicioAluno < Exercicio,
    SaudeMentalAluno < SaudeMental.


%Obtem uma lista de todos os alunos que não t~em hábitos saudáveis
alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos) :-
    findall(Id, filtraSaude(Id, HorasSono, Exercicio, SaudeMental), ListaAlunos).

%Averigua se um aluno teve mais que Nota no seu exame
notaAlta(Id, Nota) :-
    estudante(Id, _, _),
    exame(Id, NotaExame),
    NotaExame > Nota.

%Averigua se um aluno tem mais que HorasEcra horas de ecrã(para atividades lúdicas)
muitasHoras(Id, HorasEcra) :-    
    atividade(Id, _, Ecra, _),
    Ecra > HorasEcra.

%Averigua se o aluno tem notas acima do limite definido e horas de ecra acima do limite
notasAltaMuitasHoras(Id, HorasEcra, Nota) :-
    notaAlta(Id, Nota),
    muitasHoras(Id, HorasEcra).

%Estima a probabilidade de um aluno com muitas horas ligado a ecrãs ter uma nota alta
probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :- 
    findall(Id, notasAltaMuitasHoras(Id, HorasEcra, Nota), NotasHoras),
    length(NotasHoras, NotasHorasNumero),
    findall(Id, muitasHoras(Id, HorasEcra), Horas),
    length(Horas, HorasNumero),
    arredonda(NotasHorasNumero / HorasNumero, Probabilidade).

%Função auxiliar
subtrai(Valor, X, Resposta) :-
    Resposta is X-Valor.

%Subtrai Valor a todos os elementos de uma lista
subtraiValorDeLista([], _, []).
subtraiValorDeLista(Lista, Valor, Resultado) :- 
    maplist(subtrai(Valor), Lista, Resultado).

%Função auxiliar
quadrado(X, Resposta) :-
    Resposta is X**2.

%Soma o quadrado de todos os elementos de uma lista
somaQuadrados([], 0).  
somaQuadrados(Lista, Resultado) :- 
    maplist(quadrado, Lista, ListaQuadrados),
    sum_list(ListaQuadrados, Resultado).

%Função auxiliar
multiplicacao(X, Y, Res) :-
    Res is X * Y.

%Para duas listas, multiplica os elementos que estão na mesma posicao e soma os produtos
produtoEscalar(Lista1, Lista2, Resultado) :- 
    length(Lista1, L1),
    length(Lista2, L2),
    L1 == L2,
    maplist(multiplicacao, Lista1, Lista2, Produtos),
    sum_list(Produtos, Resultado).


%Para duas listas, calcula o Coeficiente de Correlação de Pearson entre 
%os valores nelas contidos
correlacao(Lista1, Lista2, Resultado) :-
    media(Lista1, Media1),
    subtraiValorDeLista(Lista1, Media1, Res1),
    media(Lista2, Media2),
    subtraiValorDeLista(Lista2, Media2, Res2),
    produtoEscalar(Res1, Res2, Numerador),
    somaQuadrados(Res1, Quadrados1),
    somaQuadrados(Res2, Quadrados2),
    Denominador is sqrt(Quadrados1) * sqrt(Quadrados2),
    arredonda(Numerador / Denominador, Resultado).



/* -----FIM DA PARTE UM DO PROJETO!!!!-----*/

/*-----Inicio da parte Dois do projeto!-----*/


tamanho('',0).
tamanho(Palavra, Tamanho) :-
    string_chars(Palavra, Lista),
    length(Lista, Tamanho).
    
verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2) :-
    string_chars(Palavra1, CaracteresPalavra1),
    string_chars(Palavra2, CaracteresPalavra2),
    length(CaracteresPalavra1, L1),
    length(CaracteresPalavra2, L2),
    L1 == L2.

quantasN(Id, N, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), tamanho(Palavra, N)), Filtrada),
    length(Filtrada, Quantas).


quantasC(Id, C, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), string_chars(Palavra, [C | _])), Filtrada),
    length(Filtrada, Quantas).


apagaElemento(Elemento, Lista1, Lista2) :-
    select(Elemento, Lista1, Lista2), !.
apagaElemento(_, Lista, Lista).


posicoesPalavra(Palavra, Posicoes) :-
    string_chars(Palavra, Lista),
    findall((Elemento, Posicao), nth1(Posicao, Lista, Elemento), PosicoesPorOrdenar),
    sort(PosicoesPorOrdenar, Posicoes).


compara(Elemento1, Elemento2, Resultado) :-
    Elemento1 == Elemento2 -> Resultado is 2;
    Resultado is 0.

pista1(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(compara, Char1, Char2, Pista).


classifica(PalavraMisterio, CharMisterio, CharPalpite, Resultado) :-
    CharMisterio == CharPalpite -> (Resultado is 2, !);
    member(CharPalpite, PalavraMisterio) -> (Resultado is 1, !);
    Resultado is 0.

pista2(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(classifica(Char1), Char1, Char2, Pista).


letrasDisponiveis([], [], []).
letrasDisponiveis([M | Misterio], [P | Palpite], Letras) :-
    M == P, !,
    letrasDisponiveis(Misterio, Palpite, Letras).
letrasDisponiveis([M | Misterio], [_| Palpite], [M | Letras]) :-
    letrasDisponiveis(Misterio, Palpite, Letras).

filtrar([], [], _, []).

filtrar([M | CharMisterio], [P | CharPalpite], Letras, [2 | Resultado]) :-
    M == P, !,
    filtrar(CharMisterio, CharPalpite, Letras, Resultado).

filtrar([ _ | CharMisterio], [P| CharPalpite], Letras, [1 | Resultado]) :-
    select(P, Letras, LetrasAtualizadas), !,
    filtrar(CharMisterio, CharPalpite, LetrasAtualizadas, Resultado).

filtrar([_ | CharMisterio], [_ | CharPalpite], Letras, [0 | Resultado]) :-
    filtrar(CharMisterio, CharPalpite, Letras, Resultado).

pista3(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    letrasDisponiveis(Char1, Char2, Letras),
    filtrar(Char1, Char2, Letras, Pista). 


/* ----- FIM DA PARTE 2 ----- */



/* ----- Inicio da parte 3 ----- */

processaRestricao(terror(Filme), Programacao) :-
    Filme \== empty,
    (nth1(Index, Programacao, Filme),
    \+ member(Index, [1, 2, 5, 6])
     ; true).

processaRestricao(soPode(Filme, Sessao), Programacao) :-
    Filme \== empty,
    nth1(Sessao, Programacao, Filme).

processaRestricao(nunca(Filme, Sessao), Programacao) :-
    nth1(Sessao, Programacao, Outro),
    Outro \== Filme.

processaRestricao(seguido(Filme1, Filme2), Programacao) :-
    nth1(Index1, Programacao, Filme1),
    Index2 is Index1 + 1,
    nth1(Index2, Programacao, Filme2),
    Index1 \== 4.

processaRestricao(naoSeguido(Filme1, Filme2), Programacao) :-
    \+(nth1(Index1, Programacao, Filme1),
       nth1(Index2, Programacao, Filme2),
       (Index2 is Index1 + 1 ; Index1 is Index2 + 1), 
       \+ (Index1 =< 4, Index2 > 4),                  
       \+ (Index2 =< 4, Index1 > 4)).


processaRestricao(antes(Filme1, Filme2), Programacao) :-
    nth1(Sessao1, Programacao, Filme1),
    nth1(Sessao2, Programacao, Filme2),
    Sessao1 < Sessao2.

/*
[f1, f2, f3, f4, f5, f6, f7]

[[hip1, hip2,...], [hip1, hip2, ...],...]

terror(Filme)
soPode(FilmeSessao)
nunca(ilme, sessao)
seguido(Filme1, Filme2)
naoSeguido(FIlme1, Filme2)
antes(Filme1, Filme2)

sab 14h 17h 20h 23h
dom 14h 17h 20h

terror nao de 14h e 17h
*/
processaTodasRestricoes([], _).
processaTodasRestricoes([Restricao | Restricoes], Programacao) :-
    processaRestricao(Restricao, Programacao),
    processaTodasRestricoes(Restricoes, Programacao).

maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao) :-
    length(ListaFilmes, NFilmes),
    M is 7 - NFilmes,
    length(ListaEmpty, M),
    maplist(=(empty), ListaEmpty),
    append(ListaFilmes, ListaEmpty, TodosFilmes),
    setof(Programacoes, (permutation(TodosFilmes, Programacoes), 
    processaTodasRestricoes(ListaRestricoes, Programacoes)), Programacao).
%lista ordenada sem elementos repetidos (setof?) com listas das possiveis sequencias
%(mais q 1solucao ou nenhuma)

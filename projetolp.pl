:- encoding(utf8).
% Irina Cojocari 117890
:- style_check(-discontiguous).
:- set_prolog_flag(answer_write_options,[max_depth(0)]). 
:- ['codigoAuxiliar.pl']. 
:- ['bd_estudantes.pl']. 
:- ['listas_palavras.pl']. 
:- ['jogar.pl'].

/* -----Inicio da parte um do projeto-----*/

/*  
media(+ ListaValores, - Valor) is det
Calcula a média dos valores em ListaValores, com 2 casas decimais

ListaValores: lista com os valores dos quais se pretende obter a média

Valor: Média dos valores contidos na lista
*/

media([], 0) :- !.
media(ListaValores, Media) :- 
    sum_list(ListaValores, Soma),
    length(ListaValores, Contagem),
    arredonda(Soma / Contagem, Media).


/* 
filtraIdade( +IdadeMin, -IdadeMax, -Nota, -Id).
Predicado auxiliar para 'mediaNotasPorIdade'; Se o estudante tem entre IdadeMin e
IdadeMax, obtem a sua nota e id.
*/

filtraIdade(IdadeMin, IdadeMax, Nota, Id) :- 
    estudante(Id, Idade, _), 
    Idade =< IdadeMax,
    Idade > IdadeMin,
    exame(Id, Nota).

/* 
mediaNotasPorIdade( +IdadeMin, +Idademax, -Media) is det
Calcula a media das notas dos alunos de um determinado intervalo de idades
*/

mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota, filtraIdade(IdadeMin, IdadeMax, Nota, _), ListaNotas), 
    media(ListaNotas, Media).


/*  
filtraGenero(+GeneroPretendido, -FrequenciaAulas, -Id)
Predicado auxiliar de freqPorGenero.
Obtem o número de vezes que um aluno frequentou as aulas, se este for do genero
pretendido.
*/

filtraGenero(GeneroPretendido, FrequenciaAulas, Id) :-
    estudante(Id, _, GeneroPretendido),
    atividade(Id, _, _, FrequenciaAulas).


/*  
freqPorGenero(+Genero, -MediaFreq) is det
Calcula a media de vezes que os alunos de um dado genero frequentam as aulas
*/

freqPorGenero(Genero, MediaFreq) :-
    findall(FrequenciaAulas, filtraGenero(Genero, FrequenciaAulas, _), ListaFreq),
    media(ListaFreq, MediaFreq).


/*  
filtraSaude(+Id, +HorasSono, +Exercicio, +SaudeMental)
Averigua se um dado aluno está abaixo dos limites considerados saudaveis no que diz
respeito a horas de sono, frequência com que faz exercício, qualidade da alimentação
e saúde mental, tendo o valor True se o aluno está fora desses limites.
Predicado auxiliar de alertaSaude
Devolve Verdadeiro/Falso (Se o aluno "dispara" o alerta ou não)
*/

filtraSaude(Id, HorasSono, Exercicio, SaudeMental) :-
    estudante(Id, _, _),
    saude(Id, Sono, 'fraca', ExercicioAluno, SaudeMentalAluno),
    Sono < HorasSono,
    ExercicioAluno < Exercicio,
    SaudeMentalAluno < SaudeMental.


/*  
alertaSaude(+HorasSono, +Exercicio, +SaudeMental, -ListaAlunos) is det
Obtém uma lista de todos os alunos em estado de alerta no que toca à sua saúde
(mental/física).
Devolve uma lista com os Ids dos alunos para os quais se deve estar alerta.
*/

alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos) :-
    findall(Id, filtraSaude(Id, HorasSono, Exercicio, SaudeMental), ListaAlunos).

/*
Condição auxiliar para probEcraNotasAltas (Verifica se o aluno tem nota mais alta que a
pretendida).
*/

notaAlta(Id, Nota) :-
    estudante(Id, _, _),
    exame(Id, NotaExame),
    NotaExame > Nota.

/*
Condição auxiliar para probEcraNotasAltas (Verifica se o aluno passa mais 
horas à frente de ecrãs que o pretendido).
*/

muitasHoras(Id, HorasEcra) :-    
    atividade(Id, _, Ecra, _),
    Ecra > HorasEcra.

/*
Condição auxiliar para probEcraNotasAltas (Verifica se o aluno satisfaz notaAlta
e muitasHoras).
*/

notasAltaMuitasHoras(Id, HorasEcra, Nota) :-
    notaAlta(Id, Nota),
    muitasHoras(Id, HorasEcra).

/*  
probEcraNotasAltas(+HorasEcra, +Nota, -Probabilidade).
Estima a probabilidade de um aluno com muitas horas ligado a ecrãs ter uma nota alta
*/

probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :- 
    findall(Id, notasAltaMuitasHoras(Id, HorasEcra, Nota), NotasHoras),
    length(NotasHoras, NotasHorasNumero),
    findall(Id, muitasHoras(Id, HorasEcra), Horas),
    length(Horas, HorasNumero),
    arredonda(NotasHorasNumero / HorasNumero, Probabilidade).


/*  
subtraiValorDeLista(+Lista, +Valor, -Resultado).
Subtrai um dado valor a todos os elementos de uma lista
*/
subtraiValorDeLista([], _, []) :- !.    %Corte verde (eficiencia)
subtraiValorDeLista([Num|Lista], Valor, [NumNovo|Resultado]) :-
    NumNovo is Num - Valor,
    subtraiValorDeLista(Lista, Valor, Resultado).


/*  
somaQuadrados(+Lista, -Resultado).
Somatório do quadrado (x^2) de todos os elementos de uma lista
*/
somaQuadrados([], 0) :- !.  %Corte verde (eficiencia)
somaQuadrados([Num|Lista], Resultado) :-
    somaQuadrados(Lista, SomaResto),
    Resultado is SomaResto + (Num**2).


/*  
produtoEscalar(+Lista1, +Lista2, -Resultado).
Dadas duas listas, calcula o produto escalar delas, isto é, calcula o somatório do
produto dos elementos com a mesma posição nas listas.o
*/
produtoEscalar([], [], 0) :- !.  %Corte verde (eficiencia)
produtoEscalar([Num1|Lista1], [Num2|Lista2], Resultado) :- 
    produtoEscalar(Lista1, Lista2, SomaResto),
    Resultado is SomaResto + (Num1 * Num2).


/*  
correlacao(+Lista1, +Lista2, -Resultado).
Para duas listas, calcula o Coeficiente de Correlação de Pearson entre 
os valores nelas contidos
*/

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


/*-----Inicio da parte dois do projeto!-----*/


/*  
tamanho(+Palavra, -Tamanho).
Determina o tamanho de uma palavra
*/

tamanho('',0) :- !.  %Corte verde (eficiencia)
tamanho(Palavra, Tamanho) :-
    string_chars(Palavra, Lista),
    length(Lista, Tamanho).


/*  
verificaECalcula(+Palavra1, +Palavra2, -CaracteresPalavra1, -CaracteresPalavra2).
Calcula o tamanho de duas palavras e verifica se têm o mesmo comprimento, 
devolvendo a lista de caracteres que constituem cada palavra.
*/
verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2) :-
    string_chars(Palavra1, CaracteresPalavra1),
    string_chars(Palavra2, CaracteresPalavra2),
    length(CaracteresPalavra1, L),
    length(CaracteresPalavra2, L). %se tiverem o mesmo comprimento, unifica
   
/*
quantasN(+Id, +N, -Quantas).
Calcula o número de palavras numa lista que têm N caracteres
*/
quantasN(Id, N, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), tamanho(Palavra, N)), Filtrada),
    length(Filtrada, Quantas).


/*
quantasC(+Id, +C, -Quantas).
Calcula o número de palavras de uma lista que começam com um dado caractere
*/
quantasC(Id, C, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), string_chars(Palavra, [C | _])), Filtrada),
    length(Filtrada, Quantas).


/*
apagaElemento(+Elemento, +Lista1, -Lista2) is det
Apaga um elemento de uma lista.
*/
apagaElemento(Elemento, Lista1, Lista2) :-
    select(Elemento, Lista1, Lista2), !.    %apaga apenas a primeira instância do elemento
apagaElemento(_, Lista, Lista).     %se o elemento não está na lista, a lista mantem-se


/* 
posicoesPalavra(+Palavra, -Posicoes)
Dada uma palavra, devolve uma lista constituida por todos os pares 
(caractere, posicao na palavra).
*/

posicoesPalavra(Palavra, Posicoes) :-
    string_chars(Palavra, Lista),
    findall((Elemento, Posicao), nth1(Posicao, Lista, Elemento), PosicoesPorOrdenar),
    sort(PosicoesPorOrdenar, Posicoes).


/*
Predicado auxiliar de pista1 (is det)
Verifica se dois elementos são iguais, devolvendo 2 se se verificar,
devolvendo 0 caso contrário.
*/
compara(X, X, 2) :- !. %Corte Vermelho (considera apenas o 2, caso unifique)
compara(_, _, 0).

/*
pista1(+Palavra1, +Palavra2, -Pista) is det
Dadas duas palavras, se forem do mesmo tamanho, devolve uma lista em que 2
representa elementos que correspondam e 0 representa elementos diferentes nas palavras.
*/
pista1(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(compara, Char1, Char2, Pista).


/*
classifica(+PalavraMisterio, +CharM, +Palpite, -Resultado) is det
Predicado auxiliar de pista2. Dada uma palavra e um caractere "palpite", 
se o caractere não estiver na palavra, devolve 0, se estiver, mas não na posição 
correta, devolve 1, se estiver e estiver na posição correta, devolve 2.
*/
%Corte Vermelho: Se forem iguais, não averigua outras condicoes
classifica(_, Char, Char, 2) :- !. 

classifica(PalavraMisterio, _, Palpite, 1) :-
    member(Palpite, PalavraMisterio), !.    %Corte Vermelho (não verificar ultima)

classifica(_, _, _, 0).


/*
pista2(+Palavra1, +Palavra2, -Pista) is det
Dadas duas palavras, compara-as, devolvendo uma lista de igual tamanho em que,
para caracteres iguais, se obtem um 2, para caracteres que estejam na palavra
mas não naquela posilão obtem-se 1 e se não estiverem de todo na palavra obtem-se 0.
*/
pista2(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(classifica(Char1), Char1, Char2, Pista).

/*
letrasDisponiveis(+PalavraMisterio, +Palpite, -Letras).
Predicado auxiliar de pista3.
Forma um "saco" com as letras disponíveis na palavra mistério que não estejam no mesmo
sítio na palavra palpite.
*/

letrasDisponiveis([], [], []).
%nao adiciona ao "saco", filtra/4 ja lida com esse cenario
letrasDisponiveis([M | Misterio], [M | Palpite], Letras) :- !,  
    letrasDisponiveis(Misterio, Palpite, Letras).

letrasDisponiveis([M | Misterio], [_| Palpite], [M | Letras]) :-
    letrasDisponiveis(Misterio, Palpite, Letras).


/*
filtrar(+ListaCaracteresMisterio, +ListaCaracteresPalpite, -Resultado).
Predicado auxiliar de pista3.
Se o caractere na posição atual da palavra palpite for igual ao da mesma posição
na palavra mistério, a posição correspondente na lista das pistas é 2; se não for
igual e esse caractere não estiver disponível no "saco de letras diferentes", a pista
correspondente é 1; se não for igual e o caractere não estiver disponível, a pista é 0.
*/

filtrar([], [], _, []).

filtrar([M | Misterio], [M | Palpite], Letras, [2 | Resultado]) :-
    !,  %se sao iguais, nao executa o codigo das restantes condicoes
    filtrar(Misterio, Palpite, Letras, Resultado).

filtrar([ _ | Misterio], [P| Palpite], Letras, [1 | Resultado]) :-
    select(P, Letras, LetrasAtualizadas), !, %nao executa o codigo para a proxima condicao
    filtrar(Misterio, Palpite, LetrasAtualizadas, Resultado).

filtrar([_ | Misterio], [_ | Palpite], Letras, [0 | Resultado]) :-
    filtrar(Misterio, Palpite, Letras, Resultado).


/*
pista3(+Palavra1, +Palavra2, -Pista) is det
Dadas duas palavras, compara-as, devolvendo uma lista composta por 2 (representa
caracteres iguais), 1 (caracteres existentes mas fora do lugar) e 0 (caracteres que
não estão na palavra a adivinhar).
*/
pista3(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    letrasDisponiveis(Char1, Char2, Letras),
    filtrar(Char1, Char2, Letras, Pista). 


/* ----- FIM DA PARTE DOIS DO PROJETO!!!! ----- */



/* ----- Inicio da parte três do projeto ----- */


/*
processaRestricao(+Restricao, -Programacao)
Predicado auxiliar de maratonaFilmes.
Dada uma restrição, "processa-a", assegurando que o filme correspondente não 
ocupa nenhuma posição "proibida" na programação das maratonas de filmes.
Devolve Verdadeiro caso o filme esteja num "slot" em que cumpre todas as regras,
Falso caso contrário.
*/
processaRestricao(terror(Filme), Programacao) :-
    Filme \= empty,
    (nth1(Index, Programacao, Filme),
    \+ member(Index, [1, 2, 5, 6])).

processaRestricao(soPode(Filme, Sessao), Programacao) :-
    Filme \= empty,
    nth1(Sessao, Programacao, Filme).

processaRestricao(nunca(Filme, Sessao), Programacao) :-
    nth1(Sessao, Programacao, Outro),
    Outro \= Filme.

processaRestricao(seguido(Filme1, Filme2), Programacao) :-
    nth1(Index1, Programacao, Filme1),
    Index2 is Index1 + 1,
    nth1(Index2, Programacao, Filme2),
    Index1 \= 4.

processaRestricao(naoSeguido(Filme1, Filme2), Programacao) :-
    \+ processaRestricao(seguido(Filme1, Filme2), Programacao),
    \+ processaRestricao(seguido(Filme2, Filme1), Programacao).


processaRestricao(antes(Filme1, Filme2), Programacao) :-
    nth1(Sessao1, Programacao, Filme1),
    nth1(Sessao2, Programacao, Filme2),
    Sessao1 < Sessao2.

/*
processaTodasRestricoes(+ListaRestricoes, -Programacao)
Predicado auxiliar de maratonaFilmes.
Dada uma lista de restrições, processa todas.
Devolve a lista processada de restrições; "mega restrição" composta
por todas as restrições na lista fornecida.
*/
processaTodasRestricoes([], _).

processaTodasRestricoes([Restricao | Restricoes], Programacao) :-
    processaRestricao(Restricao, Programacao),
    processaTodasRestricoes(Restricoes, Programacao).


/*
maratonaFilmes(+ListaFilmes, +ListaRestricoes, -Programacao) is det
Dada uma lista de filmes e uma de restrições, devolve todas as programações possíveis
de maratonas de filmes, de modo a que todas as restrições sejam respeitadas.
*/

maratonaFilmes(ListaFilmes, ListaRestricoes, Programacao) :-
    length(ListaFilmes, NFilmes),
    M is 7 - NFilmes,
    length(ListaEmpty, M),  %lista de "empty" de modo a completar os espaços "vagos"
    maplist(=(empty), ListaEmpty),
    append(ListaFilmes, ListaEmpty, TodosFilmes),
    findall(Programacoes, (permutation(TodosFilmes, Programacoes),  %gera todas as  
                                                               %combinacoes possiveis
    processaTodasRestricoes(ListaRestricoes, Programacoes)), ProgsDesordenados),
    sort(ProgsDesordenados, Programacao).

/* ----- FIM DA PARTE TRÊS DO PROJETO ----- */
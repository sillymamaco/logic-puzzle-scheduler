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
Calcula a média dos valores em ListaValores, com 2 casas decimais

Argumentos: ListaValores (lista com os valores dos quais se pretende obter
a média)

Devolve: Média dos valores contidos na lista
*/

media([], 0) :- !.
media(ListaValores, Media) :- 
    sum_list(ListaValores, Soma),
    length(ListaValores, Contagem),
    arredonda(Soma/Contagem, Media).


/*
Predicado auxiliar para 'mediaNotasPorIdade';
Se o estudante tem entre IdadeMin e IdadeMax, obtem a sua nota

Argumentos: IdadeMin, Idademaxima (Parâmetros que limitam a faixa etária
pretendida; números inteiros).

Devolve: Pares (Id do aluno, Nota do aluno no exame)
*/

filtraIdade(IdadeMin, IdadeMax, Nota, Id) :- 
    estudante(Id, Idade, _), 
    Idade =< IdadeMax,
    Idade > IdadeMin,
    exame(Id, Nota).

/*
Calcula a media das notas dos alunos de um determinado intervalo de idades

Argumentos: IdadeMin, Idademaxima (Parâmetros que limitam a faixa etária
pretendida; números inteiros)

Devolve: Média das notas obtidas pelos alunos nessa faixa etária
*/

mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota, filtraIdade(IdadeMin, IdadeMax, Nota, _), ListaNotas), 
    media(ListaNotas, Media).

/*
Obtem o número de vezes que um aluno frequentou as aulas, se este for do genero
pretendido.

Argumentos: Género pretendido

Devolve: Pares (Id, FrequenciaAulas)
*/

filtraGenero(GeneroPretendido, FrequenciaAulas, Id) :-
    estudante(Id, _, Genero),
    Genero == GeneroPretendido,
    atividade(Id, _, _, FrequenciaAulas).


/*
Calcula a media de vezes que os alunos de um dado genero frequentam as aulas

Argumentos: Género pretendido

Devolve: Média da quantidade de aulas frequentadas pelos alunos de um dado genero
*/

freqPorGenero(Genero, MediaFreq) :-
    findall(FrequenciaAulas, filtraGenero(Genero, FrequenciaAulas, _), ListaFreq),
    media(ListaFreq, MediaFreq).


/*
Averigua se um dado aluno está abaixo dos limites considerados saudaveis no que diz
respeito a horas de sono, frequência com que faz exercício, qualidade da alimentação
 e saúde mental, tendo o valor True se o aluno está fora desses limites.
Predicado auxiliar de alertaSaude

Argumentos: Id do Aluno, Horas de Sono, Quantidade de Exercício Físico, Saúde Mental

Devolve: Verdadeiro/Falso (Se o aluno "dispara" o alerta ou não)
*/

filtraSaude(Id, HorasSono, Exercicio, SaudeMental) :-
    estudante(Id, _, _),
    saude(Id, Sono, Alimentacao, ExercicioAluno, SaudeMentalAluno),
    Alimentacao == 'fraca',
    Sono < HorasSono,
    ExercicioAluno < Exercicio,
    SaudeMentalAluno < SaudeMental.


/*
Obtém uma lista de todos os alunos em estado de alerta no que toca à sua saúde
(mental/física).

Argumentos: Horas de sono, quantidade de exercício e nivel de saude mental 
considerados o mínimo saudável (em números inteiros).

Devolve: Lista com os Ids dos alunos para os quais se deve estar alerta.
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
Condição auxiliar para probEcraNotasAltas (Verifica se o aluno passa mais horas à frente de ecrãs
que o pretendido pretendida).
*/

muitasHoras(Id, HorasEcra) :-    
    atividade(Id, _, Ecra, _),
    Ecra > HorasEcra.

/*
Condição auxiliar para probEcraNotasAltas (Verifica se o aluno satisfaz ambas as 
condições notaAlta e muitasHoras).
*/

notasAltaMuitasHoras(Id, HorasEcra, Nota) :-
    notaAlta(Id, Nota),
    muitasHoras(Id, HorasEcra).

/*
Estima a probabilidade de um aluno com muitas horas ligado a ecrãs ter uma nota alta

Argumentos: Limites inferiores das horas de ecrã e notas a considerar.

Devolve: Probabilidade de um aluno com tantas ou mais horas à frente de ecrãs ter a nota
dada ou superior.
*/

probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :- 
    findall(Id, notasAltaMuitasHoras(Id, HorasEcra, Nota), NotasHoras),
    length(NotasHoras, NotasHorasNumero),
    findall(Id, muitasHoras(Id, HorasEcra), Horas),
    length(Horas, HorasNumero),
    arredonda(NotasHorasNumero / HorasNumero, Probabilidade).

/*
Predicado auxiliar para percorrer listas
*/

subtrai(Valor, X, Resposta) :-
    Resposta is X-Valor.

/*
Subtrai um dado valor a todos os elementos de uma lista

Argumentos: Lista a percorrer, Valor a subtrair

Devolve: Lista após se subtrair o valor a todos os elementos da original
*/

subtraiValorDeLista([], _, []).
subtraiValorDeLista(Lista, Valor, Resultado) :- 
    maplist(subtrai(Valor), Lista, Resultado).


/*
Predicado auxiliar para percorrer listas
*/

quadrado(X, Resposta) :-
    Resposta is X**2.

/*
Somatório do quadrado (x^2) de todos os elementos de uma lista

Argumentos: Lista a percorrer

Devolve: Resultado do somatório
*/

somaQuadrados([], 0).  
somaQuadrados(Lista, Resultado) :- 
    maplist(quadrado, Lista, ListaQuadrados),
    sum_list(ListaQuadrados, Resultado).


/*
Predicado auxiliar para percorrer listas
*/

multiplicacao(X, Y, Res) :-
    Res is X * Y.

/*
Dadas duas listas, calcula o produto escalar delas, isto é, calcula o somatório do
produto dos elementos com a mesma posição nas listas.

Argumentos: Lista 1 e Lista 2

Devolve: Resultado do somatório
*/

produtoEscalar(Lista1, Lista2, Resultado) :- 
    length(Lista1, L1),
    length(Lista2, L2),
    L1 == L2,
    maplist(multiplicacao, Lista1, Lista2, Produtos),
    sum_list(Produtos, Resultado).


/* 
Para duas listas, calcula o Coeficiente de Correlação de Pearson entre 
os valores nelas contidos

Argumentos: Lista 1, Lista 2

Devolve: Coeficiente de Correlação de Pearson
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
Determina o tamanho de uma palavra

Argumento: Palavra

Devolve: Tamanho/número de caracteres
*/

tamanho('',0).
tamanho(Palavra, Tamanho) :-
    string_chars(Palavra, Lista),
    length(Lista, Tamanho).


/*
Calcula o tamanho de duas palavras e verifica se têm o mesmo comprimento, 
devolvendo a lista de caracteres que constituem cada palavra.

Argumentos: Palavra 1, Palavra 2

Devolve: Lista de caracteres da palavra 1, Lista de caracteres da Palavra 2
*/

verificaECalcula(Palavra1, Palavra2, CaracteresPalavra1, CaracteresPalavra2) :-
    string_chars(Palavra1, CaracteresPalavra1),
    string_chars(Palavra2, CaracteresPalavra2),
    length(CaracteresPalavra1, L1),
    length(CaracteresPalavra2, L2),
    L1 == L2.


/*
Encontra todas as palavras numa lista que têm N caracteres

Argumentos: Id da lista, tamanho pretendido

Devolve: Número de palavras que cumprem a condição
*/

quantasN(Id, N, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), tamanho(Palavra, N)), Filtrada),
    length(Filtrada, Quantas).


/*
Encontra todas as palavras de uma lista que começam com um dado caractere

Argumentos: Id da lista, Caractere

Devolve: Numero de palavras que cumprem a condição
*/

quantasC(Id, C, Quantas) :-
    lista_palavras(Id, Lista),
    findall(Palavra, (member(Palavra, Lista), string_chars(Palavra, [C | _])), Filtrada),
    length(Filtrada, Quantas).


/*
Apaga um elemento de uma lista

Argumentos: Elemento a apagar, lista

Devolve: lista filtrada
*/

apagaElemento(Elemento, Lista1, Lista2) :-
    select(Elemento, Lista1, Lista2), !.
apagaElemento(_, Lista, Lista).


/* 
Dada uma palavra, devolve uma lista constituida por todos os pares 
(caractere, posicao na palavra).

Argumentos: Palavra

Devolve: Lista com os pares (letra, posicao)
*/

posicoesPalavra(Palavra, Posicoes) :-
    string_chars(Palavra, Lista),
    findall((Elemento, Posicao), nth1(Posicao, Lista, Elemento), PosicoesPorOrdenar),
    sort(PosicoesPorOrdenar, Posicoes).


/*
Predicado auxiliar de pista1.
Verifica se dois elementos são iguais, devolvendo 2 se se verificar,
devolvendo 0 caso contrário.

Argumentos: Elemento 1, elemento 2

Devolve: 2 ou 0
*/

compara(Elemento1, Elemento2, Resultado) :-
    Elemento1 == Elemento2 -> Resultado is 2;
    Resultado is 0.


/*
Dadas duas palavras, se forem do mesmo tamanho, devolve uma lista em que 2
representa elementos que correspondam e 0 representa elementos diferentes nas palavras.

Argumentos: Palavra 1, Palavra 2

Devolve: Lista com as pistas (2 e 0)
*/

pista1(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(compara, Char1, Char2, Pista).


/*
Predicado auxiliar de pista2
Dada uma palavra e um caractere "palpite", se o caractere não estiver na palavra, 
devolve 0, se estiver, mas não na posição correta, devolve 1, se estiver e 
estiver na posição correta, devolve 2.

Argumentos: Palavra, Caractere correspondente na palavra, caractere palpite

Devolve: 2, 1 ou 0
*/

classifica(PalavraMisterio, CharMisterio, CharPalpite, Resultado) :-
    CharMisterio == CharPalpite -> (Resultado is 2, !);
    member(CharPalpite, PalavraMisterio) -> (Resultado is 1, !);
    Resultado is 0.


/*
Dadas duas palavras, compara-as, devolvendo uma lista de igual tamanho em que,
para caracteres iguais, se obtem um 2, para caracteres que estejam na palavra
mas não naquela posilão obtem-se 1 e se não estiverem de todo na palavra obtem-se 0.

Argumentos: Palavra 1, Palavra 2

Devolve: Lista com as pistas (2, 1 e 0)
*/

pista2(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    maplist(classifica(Char1), Char1, Char2, Pista).


/*
Predicado auxiliar de pista3.
Forma um "saco" com as letras disponíveis na palavra mistério que não estejam no mesmo
sítio na palavra palpite.

Argumentos: Palavra Mistério, Palpite

Devolve: Lista com as letras restantes
*/

letrasDisponiveis([], [], []).
letrasDisponiveis([M | Misterio], [P | Palpite], Letras) :-
    M == P, !,
    letrasDisponiveis(Misterio, Palpite, Letras).
letrasDisponiveis([M | Misterio], [_| Palpite], [M | Letras]) :-
    letrasDisponiveis(Misterio, Palpite, Letras).


/*
Predicado auxiliar de pista3.
Se o caractere na posição atual da palavra palpite for igual ao da mesma posição
na palavra mistério, a posição correspondente na lista das pistas é 2; se não for
igual e esse caractere não estiver disponível no "saco de letras diferentes", a pista
correspondente é 1; se não for igual e o caractere não estiver disponível, a pista é 0.

Argumentos: Lista de caracteres a adivinhar, lista de caracteres do palpite, lista de letras
disponíveis

Devolve: Lista das pistas (2, 1 ou 0)
*/

filtrar([], [], _, []).

filtrar([M | CharMisterio], [P | CharPalpite], Letras, [2 | Resultado]) :-
    M == P, !,
    filtrar(CharMisterio, CharPalpite, Letras, Resultado).

filtrar([ _ | CharMisterio], [P| CharPalpite], Letras, [1 | Resultado]) :-
    select(P, Letras, LetrasAtualizadas), !,
    filtrar(CharMisterio, CharPalpite, LetrasAtualizadas, Resultado).

filtrar([_ | CharMisterio], [_ | CharPalpite], Letras, [0 | Resultado]) :-
    filtrar(CharMisterio, CharPalpite, Letras, Resultado).


/*
Dadas duas palavras, compara-as, devolvendo uma lista composta por 2 (representa
caracteres iguais), 1 (caracteres existentes mas fora do lugar) e 0 (caracteres que
não estão na palavra a adivinhar).

Argumentos: Palavra 1, Palavra 2

Devolve: Lista das pistas (2, 1 e 0)
*/

pista3(Palavra1, Palavra2, Pista) :-
    verificaECalcula(Palavra1, Palavra2, Char1, Char2),
    letrasDisponiveis(Char1, Char2, Letras),
    filtrar(Char1, Char2, Letras, Pista). 


/* ----- FIM DA PARTE DOIS DO PROJETO!!!! ----- */



/* ----- Inicio da parte três do projeto ----- */


/*
Predicado auxiliar de maratonaFilmes.
Dada uma restrição, "processa-a", assegurando que o filme correspondente não 
ocupa nenhuma posição "proibida" na programação das maratonas de filmes.

Argumentos: restrição(filme)

Devolve: Verdadeiro caso o filme esteja num "slot" em que cumpre todas as regras,
Falso caso contrário.
*/
processaRestricao(terror(Filme), Programacao) :-
    Filme \== empty,
    (nth1(Index, Programacao, Filme),
    \+ member(Index, [1, 2, 5, 6])).

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
    nth1(Index1, Programacao, Filme1),
    nth1(Index2, Programacao, Filme2),
    \+ (Index2 is Index1 + 1, Index1 \== 4),
    \+ (Index1 is Index2 + 1, Index2 \== 4).


processaRestricao(antes(Filme1, Filme2), Programacao) :-
    nth1(Sessao1, Programacao, Filme1),
    nth1(Sessao2, Programacao, Filme2),
    Sessao1 < Sessao2.

/*
Predicado auxiliar de maratonaFilmes.
Dada uma lista de restrições, processa todas.

Argumentos: Lista de restrições (aplicadas a filmes)

Devolve: Lista processada de restrições; "mega restrição" composta
por todas as restrições na lista fornecida.
*/

processaTodasRestricoes([], _).
processaTodasRestricoes([Restricao | Restricoes], Programacao) :-
    processaRestricao(Restricao, Programacao),
    processaTodasRestricoes(Restricoes, Programacao).


/*
Dada uma lista de filmes e uma de restrições, devolve todas as programações possíveis
 de maratonas de filmes, de modo a que todas as restrições sejam respeitadas.

Argumentos: Lista de filmes, Lista de restrições

Devolve: Lista de programações possíveis
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
:- encoding(utf8).
% Irina Cojocari 117890
:- style_check(-discontiguous).
:- set_prolog_flag(answer_write_options,[max_depth(0)]). 
:- ['codigoAuxiliar.pl']. 
:- ['bd_estudantes.pl']. 
:- ['listas_palavras.pl']. 


contagemSoma([], 0, 0).
contagemSoma([Primeiro | Lista], Contagem +1, Soma + Primeiro) :-
    contagemSoma(Lista, Contagem, Soma).

media([], 0) :- !.
media(ListaValores, Media) :- 
    contagemSoma(ListaValores, Contagem, Soma),
    arredonda((Soma / Contagem), Media).


filtraIdade(IdadeMin, IdadeMax, Nota, Id) :- 
    estudante(Id, Idade, _), 
    Idade =< IdadeMax,
    Idade > IdadeMin,
    exame(Id, Nota).

mediaNotasPorIdade(IdadeMin, IdadeMax, Media) :-
    findall(Nota, filtraIdade(IdadeMin, IdadeMax, Nota, _), ListaNotas), 
    media(ListaNotas, Media).


filtraGenero(GeneroPretendido, FrequenciaAulas, Id) :-
    estudante(Id, _, Genero),
    Genero == GeneroPretendido,
    atividade(Id, _, _, FrequenciaAulas).

freqPorGenero(Genero, MediaFreq) :-
    findall(FrequenciaAulas, filtraGenero(Genero, FrequenciaAulas, _), ListaFreq),
    media(ListaFreq, MediaFreq).


filtraSaude(Id, HorasSono, Exercicio, SaudeMental) :-
    estudante(Id, _, _),
    saude(Id, Sono, Alimentacao, ExercicioAluno, SaudeMentalAluno),
    Alimentacao == 'fraca',
    Sono < HorasSono,
    ExercicioAluno < Exercicio,
    SaudeMentalAluno < SaudeMental.

alertaSaude(HorasSono, Exercicio, SaudeMental, ListaAlunos) :-
    findall(Id, filtraSaude(Id, HorasSono, Exercicio, SaudeMental), ListaAlunos).


notaAlta(Id, Nota) :-
    estudante(Id, _, _),
    exame(Id, NotaExame),
    NotaExame > Nota.

muitasHoras(Id, HorasEcra) :-    
    atividade(Id, _, Ecra, _),
    Ecra > HorasEcra.

notasAltaMuitasHoras(Id, HorasEcra, Nota) :-
    notaAlta(Id, Nota),
    muitasHoras(Id, HorasEcra).

probEcraNotasAltas(HorasEcra, Nota, Probabilidade) :- 
    findall(Id, notasAltaMuitasHoras(Id, HorasEcra, Nota), NotasHoras),
    contagemSoma(NotasHoras, NumeroNotasHoras, _),
    findall(Id, muitasHoras(Id, HorasEcra), Horas),
    contagemSoma(Horas, NumeroHoras, _),
    arredonda(NumeroNotasHoras / NumeroHoras, Probabilidade).

/*
 subtraiValorDeLista(Lista, Valor, Resultado) é verdade se Resultado for a lista que
se obtém depois de tirar o valor Valor de todos os elementos da lista Lista;
– somaQuadrados(Lista, Resultado) é verdade se Resultado for a lista que se obtém depois
de se somar o quadrado de cada elemento da lista Lista.
*/


/*
– produtoEscalar(Lista1, Lista2, Resultado) é verdade se Resultado for a lista que se
obtém depois de se calcular o produto escalar entre os elementos de Lista1 e Lista2 (isto é,
somar os resultados das multiplicações dos elementos nas mesmas posições nas duas listas).
Este predicado deve falhar se as listas Lista1 e Lista2 não tiverem o mesmo tamanho.
*/


/*
– correlação(Lista1, Lista2, Resultado) é verdade se Resultado for a lista que se obtém
depois de se calcular a correlação entre os valores das listas Lista1 e Lista2, de acordo com
a Equação 2.
*/


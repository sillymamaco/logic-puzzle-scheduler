:- encoding(utf8).
% Irina Cojocari 117890
:- style_check(-discontiguous).
:- set_prolog_flag(answer_write_options,[max_depth(0)]). 
:- ['codigoAuxiliar.pl']. 
:- ['bd_estudantes.pl']. 
:- ['listas_palavras.pl']. 


media([], 0) :- !.
media(ListaValores, Media) :- 
    sum_list(ListaValores, Soma),
    length(ListaValores, Contagem),
    arredonda(Soma/Contagem, Media).


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
    length(NotasHoras, NotasHorasNumero),
    findall(Id, muitasHoras(Id, HorasEcra), Horas),
    length(Horas, HorasNumero),
    arredonda(NotasHorasNumero / HorasNumero, Probabilidade).

subtrai(Valor, X, Resposta) :-
    Resposta is X-Valor.
subtraiValorDeLista([], _, []).
subtraiValorDeLista(Lista, Valor, Resultado) :- 
    maplist(subtrai(Valor), Lista, Resultado).

quadrado(X, Resposta) :-
    Resposta is X**2.
somaQuadrados([], 0).  
somaQuadrados(Lista, Resultado) :- 
    maplist(quadrado, Lista, ListaQuadrados),
    sum_list(ListaQuadrados, Resultado).


multiplicacao(X, Y, Res) :-
    Res is X * Y.
produtoEscalar(Lista1, Lista2, Resultado) :- 
    length(Lista1, L1),
    length(Lista2, L2),
    L1 == L2,
    maplist(multiplicacao, Lista1, Lista2, Produtos),
    sum_list(Produtos, Resultado).




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

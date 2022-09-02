



# Índice de Velocidade do Crescimento Micelial - IVCM {#ivcm}

Complementar a AACCM, avalia a velocidade média do crescimento micelial. Pode ser utilizado quando as curvas de progresso tem duração diferentes.


Retomando o exemplo da Figura \@ref(fig:curvaprog), o IVCM é calculado pela seguinte fórmula: 



$$
IVCM =  \sum ((X_{i+1}-X_i) \cdot (T_{i+1}-T_i))
$$

No software R, existe a função `mvi` do pacote `phytopathologyr` que efetua este cálculo

A função precisa de dois vetores:

1. Tempo em que cada medida foi realizada (no exemplo abaixo, dias após a repicagem da colônia).
2. Quantificação da doença (no exemplo abaixo, o diâmetro da colônia em cada tempo.)


```r
tempo <- c(0, 1, 2, 3, 5, 6, 7, 8)
diam <- c(0.5, 0.6, 0.7, 1.2, 3.1, 5.2, 6.6, 8.8)
library(phytopathologyr)
mvi(y = diam, time = tempo)
```

```
## [1] 1.05
```

## Como utilizar o IVCM na análise de experimentos

 O IVCM segue a mesma lógica utilizada no cálculo da AACCM. Para mais detalhes, consulte o item \@ref(aaccmexp).




O cálculo do IVCM para cada repetição de cada tratamento é feito com a função `mvi` do pacote `phytopathologyr`: 


```r
library(phytopathologyr)
dados_ivcm <- dados_ivcm %>%
  group_by(trat, rep) %>%
  summarise(ivcm = mvi(diametro, tempo)) %>%
  ungroup()
```

```
## `summarise()` has grouped output by 'trat'. You can override using the
## `.groups` argument.
```


```
## Rows: 50
## Columns: 3
## $ trat <chr> "102B", "102B", "102B", "102B", "102B", "111B", "111B", "111B", "…
## $ rep  <dbl> 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2,…
## $ ivcm <dbl> 1.6756552, 1.6783320, 1.6114918, 1.8541976, 1.6912924, 1.4018704,…
```


Por fim, o resultado destes cálculos pode ser salvo para utilização nas análises posteriores. O formato *.csv* é idela para salvar, visto que sua importação pelo R é facilmente executado e pode ser aberto em qualquer computador para leitura.


```r
readr::write_csv2(dados_ivcm, "data/ivcm.csv")
```





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
  group_by(oe, dose, rep) %>%
  summarise(area = mvi(diametro, tempo)) %>%
  ungroup()
```

```
## `summarise()` has grouped output by 'oe', 'dose'. You can override using the
## `.groups` argument.
```

```r
dados_ivcm
```

```
## # A tibble: 40 × 4
##    oe     dose   rep     area
##    <chr> <dbl> <dbl>    <dbl>
##  1 Cravo    50     1  2.12   
##  2 Cravo    50     2  2.07   
##  3 Cravo    50     3  1.99   
##  4 Cravo    50     4  2.06   
##  5 Cravo    50     5  2.01   
##  6 Cravo   150     1  1.54   
##  7 Cravo   150     2 -0.00961
##  8 Cravo   150     3  1.20   
##  9 Cravo   150     4 -0.00303
## 10 Cravo   150     5  0.558  
## # … with 30 more rows
```

Por fim, o resultado destes cálculos pode ser salvo para utilização nas análises posteriores. O formato *.csv* é idela para salvar, visto que sua importação pelo R é facilmente executado e pode ser aberto em qualquer computador para leitura.


```r
readr::write_csv2(dados_ivcm, "data/ivcm.csv")
```

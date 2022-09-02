



# Análise de sobrevivência {#surv}

Na análise de sobrevivência a variável dependente é o tempo até ocorrência de determinado evento. Compara-se a rapidez com que ocorreu determinado evento, ao contrário de comparar as percentagens de ocorrência deste evento ao final de determinado tempo.

É a técnica ideal para analisar respostas binárias (ter ou não ter um evento) em estudos temporais.


No momento da análise, podem haver indivíduos censurados, isto é, que não desenvolveram o evento até o fim do tempo de observação do estudo (independentemente do motivo).

## Curva de sobrevivência de Kaplan-Meier

As curvas apresentam uma forma de “escada”. No eixo vertical está a porcentagem de sobrevivência, ou seja, a probabilidade de não ocorrer o evento.




## Exemplo de uma Análise de Sobrevivência

Considere os dados presentes na planilha [surv.xlsx](data/surv.xlsx).

Os dados representam a germinação de escleródios de *S. rolfsii* submetidos a tratamentos com óleo essencial de Cravo a 5000 ppm em diferentes tempos (30, 90 e 180 minutos).

A organização da planilha deve ser feita rigorosamente desta forma:
 
 * 1ª coluna: nome dos tratamentos;
 * 2ª coluna: número das repetições;
 * 3ª coluna: número de indivíduos em cada repetição;
 * 4ª coluna em diante: número de indivíduos que apresentaram o evento estudado com o nome das colunas representando o tempo;
 * Última coluna: números de indivíduos censurados.

Caso esta organização seja seguida rigorosamente, podemos utilizar a função [`surv_data`](script/surv_data.R) para preparar os dados para a Análise de sobrevivência.



```r
source("script/surv_data.R")
sobrev <- readxl::read_excel("data/surv.xlsx", skip=2) %>% surv_data()
```


Iniciamos então a análise com o pacote `survival`:


```r
library(survival)
an_sobrev <- survfit(Surv(time, status)~trat, data=sobrev)
an_sobrev
```

```
## Call: survfit(formula = Surv(time, status) ~ trat, data = sobrev)
## 
##               n events median 0.95LCL 0.95UCL
## trat=CR030   48     47    7.5       7       9
## trat=CR090   48     45    7.0       6       7
## trat=CR180   48      0     NA      NA      NA
## trat=TEST030 48     48    3.0       2       4
## trat=TEST090 48     48    3.0       2       4
## trat=TEST180 48     48    3.0       3       4
```

```r
summary(an_sobrev, censored = TRUE)
```

```
## Call: survfit(formula = Surv(time, status) ~ trat, data = sobrev)
## 
##                 trat=CR030 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     3     48       2   0.9583  0.0288        0.903        1.000
##     4     46       6   0.8333  0.0538        0.734        0.946
##     5     40       3   0.7708  0.0607        0.661        0.899
##     7     37      13   0.5000  0.0722        0.377        0.663
##     8     24       7   0.3542  0.0690        0.242        0.519
##     9     17       6   0.2292  0.0607        0.136        0.385
##    10     11       1   0.2083  0.0586        0.120        0.362
##    12     10       9   0.0208  0.0206        0.003        0.145
## 
##                 trat=CR090 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     3     48       3   0.9375  0.0349       0.8715        1.000
##     4     45       2   0.8958  0.0441       0.8135        0.987
##     5     43       8   0.7292  0.0641       0.6137        0.866
##     6     35       6   0.6042  0.0706       0.4805        0.760
##     7     29      14   0.3125  0.0669       0.2054        0.475
##     8     15       6   0.1875  0.0563       0.1041        0.338
##     9      9       5   0.0833  0.0399       0.0326        0.213
##    12      4       1   0.0625  0.0349       0.0209        0.187
## 
##                 trat=CR180 
##         time       n.risk      n.event     survival      std.err lower 95% CI 
##           12           48            0            1            0            1 
## upper 95% CI 
##            1 
## 
##                 trat=TEST030 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     2     48      23   0.5208  0.0721       0.3971        0.683
##     3     25       8   0.3542  0.0690       0.2417        0.519
##     4     17      12   0.1042  0.0441       0.0454        0.239
##     5      5       4   0.0208  0.0206       0.0030        0.145
##     6      1       1   0.0000     NaN           NA           NA
## 
##                 trat=TEST090 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     2     48      19   0.6042  0.0706       0.4805        0.760
##     3     29       9   0.4167  0.0712       0.2981        0.582
##     4     20      11   0.1875  0.0563       0.1041        0.338
##     5      9       7   0.0417  0.0288       0.0107        0.162
##     6      2       2   0.0000     NaN           NA           NA
## 
##                 trat=TEST180 
##  time n.risk n.event survival std.err lower 95% CI upper 95% CI
##     2     48      11   0.7708  0.0607       0.6606        0.899
##     3     37      18   0.3958  0.0706       0.2791        0.561
##     4     19       8   0.2292  0.0607       0.1364        0.385
##     5     11       8   0.0625  0.0349       0.0209        0.187
##     6      3       3   0.0000     NaN           NA           NA
```

Comparação pareada (pairwise) entre duas curvas de sobrevivência utilizando o teste G-rho (logrank test).

No exemplo abaixo, testou-se a diferença entre os tratamentos *TETS030* e *CR030*.



```r
sobrev %>% filter(trat=="TEST030" | trat=="CR030") %>% 
survdiff(Surv(time, status) ~ trat, data = .)
```

```
## Call:
## survdiff(formula = Surv(time, status) ~ trat, data = .)
## 
##               N Observed Expected (O-E)^2/E (O-E)^2/V
## trat=CR030   48       47     74.4      10.1      78.4
## trat=TEST030 48       48     20.6      36.5      78.4
## 
##  Chisq= 78.4  on 1 degrees of freedom, p= <2e-16
```

E as curvas de sobrevivência podem ser plotadas com o pacote `ggplot2`, utilizando a geometria `geom_step`.



```r
 g <-
    data.frame(trat=summary(an_sobrev, c = T)$strata,
          time=summary(an_sobrev, c = T)$time,
          surv=summary(an_sobrev, c = T)$surv)

g
```

```
##            trat time       surv
## 1    trat=CR030    3 0.95833333
## 2    trat=CR030    4 0.83333333
## 3    trat=CR030    5 0.77083333
## 4    trat=CR030    7 0.50000000
## 5    trat=CR030    8 0.35416667
## 6    trat=CR030    9 0.22916667
## 7    trat=CR030   10 0.20833333
## 8    trat=CR030   12 0.02083333
## 9    trat=CR090    3 0.93750000
## 10   trat=CR090    4 0.89583333
## 11   trat=CR090    5 0.72916667
## 12   trat=CR090    6 0.60416667
## 13   trat=CR090    7 0.31250000
## 14   trat=CR090    8 0.18750000
## 15   trat=CR090    9 0.08333333
## 16   trat=CR090   12 0.06250000
## 17   trat=CR180   12 1.00000000
## 18 trat=TEST030    2 0.52083333
## 19 trat=TEST030    3 0.35416667
## 20 trat=TEST030    4 0.10416667
## 21 trat=TEST030    5 0.02083333
## 22 trat=TEST030    6 0.00000000
## 23 trat=TEST090    2 0.60416667
## 24 trat=TEST090    3 0.41666667
## 25 trat=TEST090    4 0.18750000
## 26 trat=TEST090    5 0.04166667
## 27 trat=TEST090    6 0.00000000
## 28 trat=TEST180    2 0.77083333
## 29 trat=TEST180    3 0.39583333
## 30 trat=TEST180    4 0.22916667
## 31 trat=TEST180    5 0.06250000
## 32 trat=TEST180    6 0.00000000
```

```r
library(ggplot2)
g%>% filter(trat=="trat=CR030") %>% ggplot( aes(x=time, y=surv))+
  geom_step()
```

<img src="05-sobrev_files/figure-html/unnamed-chunk-5-1.png" width="672" />


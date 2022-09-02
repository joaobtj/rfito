



# Área Abaixo da Curva de Crescimento Micelial - AACCM {#aaccm}

É um conceito da epidemiologia que analisa o crescimento da doença em função do tempo.

É feita pela quantificação da área uma gráfico que expressa a evolução da quantidade de doença (*eixo x*) em função do tempo (*eixo y*).

No caso do crescimento micelial, observado em placas de Petri, a quantidade de doença é medida pelo diâmetro ou raio da colônia.

Na figura abaixo é mostrado um exemplo de uma curva de progresso da doença.

<div class="figure">
<img src="02-area_files/figure-html/curvaprog-1.png" alt="Exemplo de uma curva de progresso da doença." width="672" />
<p class="caption">(\#fig:curvaprog)Exemplo de uma curva de progresso da doença.</p>
</div>


A área abaixo da curva pode ser calculada pelo método dos trapézios, cuja fórmula é a seguinte:

$$
AAC = \frac{1}{2} \sum ((X_{i+1}+X_i) \cdot (T_{i+1}-T_i))
$$

No software R, existe a função `audpc` do pacote `phytopathologyr` que efetua este cálculo

A função precisa de dois vetores:

1. Tempo em que cada medida foi realizada (no exemplo abaixo, dias após a repicagem da colônia).
2. Quantificação da doença (no exemplo abaixo, o diâmetro da colônia em cada tempo.)


```r
tempo <- c(0, 1, 2, 3, 5, 6, 7, 8)
diam <- c(0.5, 0.6, 0.7, 1.2, 3.1, 5.2, 6.6, 8.8)
library(phytopathologyr)
audpc(y = diam, time = tempo)
```

```
## [1] 24.2
```

## Como utilizar a AACCM na análise de experimentos {#aaccmexp}

 A AACCM é um valor único que integra a evolução da curva de progresso da doença em todo o tempo de avaliação.
 
::: {.rmdwarning}

As curvas de progressos só podem ser comparadas entre si quando tem exatamente o mesmo tempo de duração, isto é, o tempo de avaliação deve ser exatamente igual.

:::
 
 Em experimentos comparativos, devemos calcular a AACCM para cada repetição de cada tratamento, afim de prossegurimos com as análises estatísticas posteriormente.
 
 O primeiro passo é digitar os seus dados em um formato organizado e passível de leitura pelo software R. Vou exemplificar a digitação em uma planilha do Excel, pois é o formato amplamente utilizado em nosso laboratório.
 
 A planilha do Excel deve ser organizada da seguinte forma:
 
<div class="figure">
<img src="image/excel_diam.png" alt="Exemplo de planilha do Excel"  />
<p class="caption">(\#fig:excelaaccm)Exemplo de planilha do Excel</p>
</div>
 

 
 
 É recomendável utilizar as primeiras linhas para fazer uam descrição dos dados apresentadas (metadados). Utilize quantas linhas desejar, pois estas serão ignoradas no momento da importação da planilha para o R. Neste exemplo, as 6 primeiras linhas são auxiliares, e os dados propriamente ditos começam na linha 7.
 
 As primeiras colunas devem conter os tratamentos ou fatores e as repetições.
 
 As colunas seguintes seguem um padrão: primeira medida do diâmetro (A), segunda medida do diâmetro (B) e média destas duas medidas. Esta última recebe no cabeçalho o momento em que foi efetuada a medição, seja a data, data e hora, a depender do planejamento do seu experimento. 
 
 Com a planilha do Excel devidamente preenchida e todos os valores conferidos, podemos seguir com a importação desta para o ambiente do R. 
 
 [Uma planilha de exemplo está aqui para download.](data/aaccm.xlsx)
 
 Para isso, utilizamos a função `read_excel` do pacote `readxl`
 

```r
dados_aaccm <- readxl::read_excel("data/aaccm.xlsx", skip = 6)
```

```
## New names:
## • `a` -> `a...4`
## • `b` -> `b...5`
## • `a` -> `a...7`
## • `b` -> `b...8`
## • `a` -> `a...10`
## • `b` -> `b...11`
## • `a` -> `a...13`
## • `b` -> `b...14`
## • `a` -> `a...16`
## • `b` -> `b...17`
## • `a` -> `a...19`
## • `b` -> `b...20`
## • `a` -> `a...22`
## • `b` -> `b...23`
## • `a` -> `a...25`
## • `b` -> `b...26`
## • `a` -> `a...28`
## • `b` -> `b...29`
## • `a` -> `a...31`
## • `b` -> `b...32`
```



```
## Rows: 40
## Columns: 33
## $ oe                   <chr> "Test", "Test", "Test", "Test", "Test", "Cravo", …
## $ dose                 <dbl> 0, 0, 0, 0, 0, 50, 50, 50, 50, 50, 150, 150, 150,…
## $ rep                  <dbl> 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2…
## $ a...4                <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ b...5                <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ `44620.333333333336` <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ a...7                <dbl> 1.0, 1.4, 0.8, 1.4, 1.3, 0.0, 0.0, 0.0, 0.0, 0.0,…
## $ b...8                <dbl> 1.30, 1.10, 1.10, 1.10, 0.31, 0.00, 0.00, 0.00, 0…
## $ `44620.756944444445` <dbl> 1.150, 1.250, 0.950, 1.250, 0.805, 0.000, 0.000, …
## $ a...10               <dbl> 3.4, 3.7, 3.0, 4.0, 3.4, 1.9, 2.0, 1.5, 2.1, 1.5,…
## $ b...11               <dbl> 3.4, 3.5, 3.1, 3.6, 3.6, 1.7, 2.0, 1.3, 2.2, 1.5,…
## $ `44621.37777777778`  <dbl> 3.40, 3.60, 3.05, 3.80, 3.50, 1.80, 2.00, 1.40, 2…
## $ a...13               <dbl> 5.2, 5.5, 5.5, 5.8, 5.3, 3.6, 3.5, 2.3, 3.6, 2.4,…
## $ b...14               <dbl> 5.3, 5.4, 5.0, 5.6, 5.5, 3.4, 3.6, 2.6, 3.6, 3.1,…
## $ `44621.765972222223` <dbl> 5.25, 5.45, 5.25, 5.70, 5.40, 3.50, 3.55, 2.45, 3…
## $ a...16               <dbl> 8.3, 8.3, 8.1, 8.6, 8.1, 6.5, 6.8, 5.9, 6.6, 5.8,…
## $ b...17               <dbl> 8.0, 8.6, 8.1, 9.0, 8.0, 6.1, 6.6, 5.4, 6.7, 6.0,…
## $ `44622.316666666666` <dbl> 8.15, 8.45, 8.10, 8.80, 8.05, 6.30, 6.70, 5.65, 6…
## $ a...19               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 8.1, 9.0, 8.0,…
## $ b...20               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 8.2, 9.0, 8.1,…
## $ `44622.720833333333` <dbl> 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 8.15, 9…
## $ a...22               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ b...23               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ `44623.380555555559` <dbl> 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9…
## $ a...25               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 8.7, 9.0, 9.0,…
## $ b...26               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ `44623.654166666667` <dbl> 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 8.85, 9…
## $ a...28               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ b...29               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ `44624.388888888891` <dbl> 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9…
## $ a...31               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ b...32               <dbl> 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0, 9.0,…
## $ `44625.279861111114` <dbl> 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9.00, 9…
```
 
 Na sequência, devemos "limpar" as colunas que não precisamos com as funções dos  pacotes `dplyr` e `tidyr`. Este passo é bastante variável em função da forma como os dados foram organizados/digitados anteriormente. Vou exemplificar conforme a planilha do Excel mostrada na figura \@ref(fig:excelaaccm).
 



```r
library(dplyr)
library(tidyr)

dados_aaccm <- dados_aaccm %>%
  select(!starts_with(c("a", "b"))) %>%
  pivot_longer(4:length(.), names_to = "tempo", values_to = "diametro") %>%
  mutate(tempo = as.numeric(tempo))
```


```
## Rows: 400
## Columns: 5
## $ oe       <chr> "Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test…
## $ dose     <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
## $ rep      <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3…
## $ tempo    <dbl> 44620.33, 44620.76, 44621.38, 44621.77, 44622.32, 44622.72, 4…
## $ diametro <dbl> 0.00, 1.15, 3.40, 5.25, 8.15, 9.00, 9.00, 9.00, 9.00, 9.00, 0…
```


Após estas instruções, é possível calcular a AACCM para cada repetição de cada tratamento, com a função `audpc` do pacote `phytopathologyr` da seguinte forma: 


```r
library(phytopathologyr)
dados_aaccm <- dados_aaccm %>%
  group_by(oe, dose, rep) %>%
  summarise(area = audpc(diametro, tempo)) %>%
  ungroup()
```

```
## `summarise()` has grouped output by 'oe', 'dose'. You can override using the
## `.groups` argument.
```


```
## Rows: 40
## Columns: 4
## $ oe   <chr> "Cravo", "Cravo", "Cravo", "Cravo", "Cravo", "Cravo", "Cravo", "C…
## $ dose <dbl> 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 300, 300, 300, 300, …
## $ rep  <dbl> 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 1, 2,…
## $ area <dbl> 30.408993, 30.724340, 28.876163, 30.799618, 29.209236, 28.395295,…
```

Por fim, o resultado destes cálculos pode ser salvo para utilização nas análises posteriores. O formato *.csv* é idela para salvar, visto que sua importação pelo R é facilmente executado e pode ser aberto em qualquer computador para leitura.


```r
readr::write_csv2(dados_aaccm, "data/area.csv")
```

---
title: "R Notebook"
output:
  html_document:
    df_print: paged
  pdf_document: default
---


# Ejercicio 2: R

Se dispone del siguiente archivo CSV con información sobre los Air Bnb de la ciudad de Milán en 2019. En el dataset, solamente aparecen apartamentos completos.

Con esta información, alumno debe realizar los siguientes procesos de analítica:

1. Cargar el archivo “Airbnb_Milan.csv” como dataframe.

```{r}
library(dplyr)
```


```{r}
Airbnb_Milan = read.csv("Airbnb_Milan.csv")
Airbnb_Milan
```

2. Crear un nuevo dataframe que contenga únicamente las siguientes columnas:
“host_is_superhost” 
“host_identity_verified” 
“bathrooms” 
“bedrooms” 
“daily_price” 
“security_deposit” 
“minimum_nights” 
“number_of_reviews” 
“review_scores_rating”

```{r}
df = Airbnb_Milan
df <- subset( df, select = c( 'host_is_superhost', 'host_identity_verified', 'bathrooms', 'bedrooms', 'daily_price', 'security_deposit', 'minimum_nights', 'number_of_reviews', 'review_scores_rating'))
df
```

3. Cambiar los factores de la variable “host_is_superhost” de 0, 1 a: “SI” y, “NO”. (investigar la función recode).

```{r}
df$host_is_superhost = recode(df$host_is_superhost, '0' = "si", '1' = "no")
head(df$host_is_superhost,100)
```
4. Cambiar los factores de la variable “host_identity_verified” de 0, 1 a: “VERIFICA” y “NO VERIFICA”.

```{r}
df$host_identity_verified = recode(df$host_identity_verified, '0' = "verifica", '1' = "no verifica")
head(df$host_identity_verified,100)
```

5. Mostrar un resumen estadístico de los datos.

```{r}
summary(df)
```

6. Filtrar el dataset por apartamentos cuyo mínimo de noches sea igual o menor que siete.

```{r}
filter(df, minimum_nights <= 7)
```

7. ¿Cuál es el precio medio por día de una habitación en función de si el anfitrión tiene verificado o no su perfil?

```{r}
df %>% group_by(host_identity_verified) %>% summarise(precio_medio = mean(daily_price))
```
El precio medio de las no verificadas es de 103.7647 y de 103.7127 en el caso de las verificadas.

8. Quién tiene más número de reseñas, ¿un super host o no super host?

```{r}
df %>% group_by(host_is_superhost) %>% summarise(reseñas = sum(number_of_reviews))
```
Existe un mayor número de reseñas en el caso de los super host con 204655 reseñas.

9. Sobre la estadística anterior ¿quién tiene la puntuación media más alta?

```{r}
df %>% group_by(host_is_superhost) %>% summarise(media_reseñas = mean(number_of_reviews))
```
La media de puntuaciones más alta es para los no super host.

10. Crea un vector categórico llamado “CATEGORÍA”, en función de que, si para la puntuación de las reseñas tiene de 0 a 49, sea “NO ACONSEJABLE”; de 50 a 75 sea “ESTÁNDAR”; y de 76 a 100 sea “TOP”.

```{r}
df["categoria"] <- factor(ifelse(df$review_scores_rating <= 49, "no aconsejable", ifelse(df$review_scores_rating <= 75, "estandar", "top")))
head(df$categoria,100)
```

11. Mostrar las frecuencias de la variable CATEGORÍA.

```{r}
table(df$categoria)
```

12. Obtener el histograma del precio por día.

```{r}
hist(df$daily_price)
```

13. Estudiar la relación entre los dormitorios y baños de forma gráfica.

```{r}
library(ggplot2)
```
```{r}
ggplot(df) + geom_point(mapping = aes(bedrooms, bathrooms)) + geom_smooth(aes(bedrooms, bathrooms), method = lm)
```

14. Mostrar un histograma del número de reseñas en función de si es un usuario verificado o no.

```{r}
library(plotly)
```

```{r}
histog <- plot_ly(data = df, x = ~df$host_identity_verified, y = ~df$review_scores_rating, type = "bar")
histog
```

15. Mostrar un histograma por cada valor de “CATEGORÍA” en el que se enseñe la cuantía del depósito de seguridad en función de si el anfitrión es super host o no.

```{r}
histog <- plot_ly( data = df, x = ~df$categoria, y = ~df$security_deposit, type = "bar", color = ~df$host_is_superhost)
histog
```

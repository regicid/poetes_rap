library(dplyr)
library(ggplot2)
library(showtext)
mentions = read.csv("~/code/poetes_rap/rap_data.csv")

font_add_google("EB Garamond", "ebgaramond")
showtext_auto()
theme_set(
  theme_minimal(base_family = "ebgaramond")
)

t = colSums(mentions[-30])
t = t[t>0]
library(stringr)
df <- data.frame(
  name = str_replace(names(t), '\\.', ' '),
  value = as.numeric(t)
)
ggplot(df, aes(x = value, y = reorder(name, value))) +
  geom_col() +
  labs(x = "Mentions", y = "Noms", title = "Mentions de poètes dans le rap français") +
  theme(axis.text.y = element_text(size = 16),axis.title = element_text(size = 16),
        axis.text.x = element_text(size = 12),
        plot.title = element_text(size = 18))

mentions$total = rowSums(mentions[-30])
corpus = read.csv("~/Downloads/corpus_rap.csv")
corpus = corpus |> select(artist,year,n_words,pageviews)
c = cbind(corpus,mentions)
d = c |> group_by(year) |> summarise(n_words = sum(n_words),total = sum(total)) |>
  filter(year %in% 1997:2024) |> mutate(freq = total/n_words)
ggplot(d,aes(year,freq)) + geom_point() + geom_point() + 
  geom_smooth(se=F,color='black') + xlab('Année') +
  ylab("Fréquence des mentions de poètes") + theme(axis.title = element_text(size = 16))

d = c |> group_by(artist) |> 
  summarise(n_words = sum(n_words),total = sum(total),pageviews = sum(pageviews)) |>
  filter(pageviews > 0,total > 2,
         !artist %in% c("Genius France [Archives]","Lucio Bukowski & Anton Serra")) |> 
  mutate(freq = total/n_words)
ggplot(d, aes(x = total, y = reorder(artist, total))) +
  geom_col() +
  labs(x = "Mentions", y = "Noms", title = "Mentions de poètes dans le rap français") +
  theme(axis.text.y = element_text(size = 13),axis.title = element_text(size = 16),
        axis.text.x = element_text(size = 12),
        plot.title = element_text(size = 18))


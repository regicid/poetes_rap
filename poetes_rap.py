from gliner import GLiNER
import pandas as pd
import re

df = pd.read_csv("hf://datasets/regicid/lrfaf_v2/corpus.csv")
model = GLiNER.from_pretrained("urchade/gliner_multi-v2.1")

labels = ["poète","philosophe"]

for i in range(10000):
  print(model.predict_entities(str(df.lyrics.values[i]),labels))
  
f = open("/Users/b.de-courson/Downloads/poetes_rap.txt","r")
a = f.read()
poetes_names = a.split('\n')[:-1]

##remove dates, remove first name and particle
#poetes_names = [i.split(' (')[0] for i in poetes if i != '']
#poetes_names =  [' '.join(s.split()[1:]) for s in poetes_names]
#poetes_names = [i.split('de ')[-1] for i in poetes_names if i != '']

mentions = {}
for p in poetes_names:
  z = df.lyrics.str.count(r'\b'+p+r'\b')
  print(p)
  print(z.sum())
  mentions[p] = z
  
M = pd.DataFrame(mentions)
M['url'] = df.url
M.to_csv("/Users/b.de-courson/Downloads/rap_data.csv",index=False)

M['total'] = M.sum(axis=1)
M['artist'] = df.artist
M['year'] = df.year
M['n_words'] = df.n_words

#check the top mentioned authors
M.iloc[:,:-5].sum().sort_values()
  
A = M.groupby('artist').agg({'total':'sum','n_words':'sum'})
A.sort_values('total')



#exclusions: sauvage, noailles, france, valéry (giscard), breton, labé; 

Y = M.groupby('year').agg({'total':'sum','n_words':'sum'})
Y['freq'] = Y.total/Y.n_words
Y['year'] = Y.index
Y = Y.loc[Y.year > 1996]
Y = Y.loc[Y.year < 2025]
import matplotlib.pyplot as plt
plt.plot(Y.year,Y.freq)
plt.show()


z = M.loc[M.artist=='Max D. Carter']

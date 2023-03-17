#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #Adjust the configuration of plots

df = pd.read_csv(r'C:\Users\LesT3\Desktop\Movie Industry Data Project\movies.csv') #r added in front of file name to fix unicode escape error

#pulls in data

df.head()


# In[2]:


#Looks for missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}'.format(col, pct_missing))


# In[3]:


#Column datatypes

df.dtypes


# In[4]:


#Drops Missing Data

df = df.dropna()

df


# In[5]:


#changes data types of columns

df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')

df


# In[6]:


#Creates consistency between year and released columns as new column

df['Year_Correct'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)


df


# In[43]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[16]:


pd.set_option('display.max_rows', None)


# In[17]:


#Remove Duplicates

df['company'].sort_values(ascending=False) #df.dropduplicates


# In[22]:


#scatter plot budget vs gross

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('Budget vs. Gross Earnings')

plt.xlabel('Gross Earnings')
plt.ylabel('Film Budget')

plt.show()


# In[23]:


df.head()


# In[29]:


#Plot buget vs gross using seaborn

sns.regplot(x='budget',y='gross', data=df, scatter_kws={"color":"green"}, line_kws={"color":"black"})


# In[32]:


#Exploring Correlations

df.corr(method ='pearson') #pearson, kendall, spearman


# In[33]:


#High Correlation between budget and gross


# In[36]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matix: Movie Values')

plt.xlabel('Movie Values')
plt.ylabel('Movie Values')

plt.show()


# In[39]:


#Company

df.head()


# In[42]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
            
df_numerized


# In[45]:


df


# In[46]:


correlation_matrix = df_numerized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matix: Movie Values')

plt.xlabel('Movie Values')
plt.ylabel('Movie Values')

plt.show()


# In[47]:


df_numerized.corr()


# In[50]:


correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()

corr_pairs


# In[51]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[52]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


#Votes and budget have the highest correlation to gross revenue

#Correlation to company is low


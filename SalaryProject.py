# Import packages

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats
import statsmodels.api as sm


# Import dataset --> https://www.kaggle.com/datasets/mohithsairamreddy/salary-data
dat = pd.read_csv('Salary_Data.csv')


#drop rows with Gender = 'Other', Salary = 0, and NaN
dat = dat.drop(dat[dat['Gender'] == 'Other'].index)
dat = dat.drop(dat[dat['Salary'] == 0].index)
dat = dat.dropna()


#view dataset
dat
dat.describe()

dat['Gender'].value_counts()


# replace education level labels
dat['Education Level'].replace("Master's Degree", "Master's", inplace=True)
dat['Education Level'].replace("Bachelor's Degree", "Bachelor's", inplace=True)
dat['Education Level'].replace("phD", "PhD", inplace=True)

dat['Education Level'].value_counts()


# check distributions
fig,ax = plt.subplots(1,3, figsize = (8, 4))
fig.tight_layout(pad=4)

fig.suptitle("Distribution Subplots")

# Age
sns.histplot(data=dat, x='Age', ax=ax[0])
ax[0].set_title('Age Distribution')
ax[0].set_xlabel('Age')

# Years of Experience
sns.histplot(data=dat, x='Years of Experience', ax=ax[1])
ax[1].set_title('Experience Distribution')
ax[1].set_xlabel('Years of Experience')

# Salary
sns.histplot(data=dat, x='Salary', ax=ax[2])
ax[2].set_title('Salary Distribution')
ax[2].set_xlabel('Salary')


# create bins for Years of Experience
exp_labels = [1, 2, 3, 4, 5, 6, 7]
dat['Expbins'] = pd.cut(x = dat['Years of Experience'], bins = 7, labels=exp_labels)


# create bins for Age
age_labels = [1, 2, 3, 4, 5]
dat['Agebins'] = pd.cut(x = dat['Age'], bins = 5, labels=age_labels)


# create female and male data subsets
fem_dat = dat.loc[dat['Gender'] == 'Female']
male_dat = dat.loc[dat['Gender'] == 'Male']



## VISUALS

# boxplot female vs male salaries
ax = sns.boxplot(data=dat, y='Salary', x='Gender')
ax.set_xlabel('Gender')
ax.set_ylabel('Salary')
ax.set_title('Salary and Gender')

# boxplot education level vs salary by gender
ax = sns.boxplot(data=dat, x = 'Education Level', y = 'Salary', hue = 'Gender')
ax.set_xlabel('Education Level')
ax.set_ylabel('Salary')
ax.set_title('Salary and Education Level by Gender')

#scatterplot years of experience vs salary by gender
ax = sns.scatterplot(data=dat, x = 'Expbins', y = 'Salary', hue = 'Gender')
ax.set_xlabel('Years of Experience')
ax.set_ylabel('Salary')
ax.set_title('Salary and Experience by Gender')



## TESTING

# t-test male vs female salaries

# subset data by gender and extract salaries
fem_sal = dat.loc[dat['Gender'] == 'Female', 'Salary']
male_sal = dat.loc[dat['Gender'] == 'Male', 'Salary']

#run test
stats.ttest_ind(fem_sal, male_sal)


male_dat.loc[male_dat['Education Level'] == "PhD", 'Salary'].mean()


# t-test starting salary differences

#subset data
starting = dat.loc[(dat['Expbins'] == 1)]
starting['Education Level'].value_counts()
starting = dat.loc[(dat['Education Level'] == "Bachelor's")]

fem_starting = starting.loc[dat['Gender'] == 'Female', 'Salary']
male_starting = starting.loc[dat['Gender'] == 'Male', 'Salary']

# t-test to compare salary averages
stats.ttest_ind(fem_starting, male_starting)


# job title differences
dat['Job Title'].value_counts()

#create subsets based on job title
managers = dat.loc[dat['Job Title'].str.contains('Manager')]
directors = dat.loc[dat['Job Title'].str.contains('Director')]

#male vs. female ratio in each position
print('M:F Ratios')
print('Managers:')
print(managers['Gender'].value_counts())
print('Directors:')
print(directors['Gender'].value_counts())

print()

#compare salaries
print('Salary differences')
print('Male Managers:')
print(managers.loc[dat['Gender'] == 'Male', 'Salary'].mean())
print('Female Managers:')
print(managers.loc[dat['Gender'] == 'Female', 'Salary'].mean())
print()
print('Male Directors:')
print(directors.loc[dat['Gender'] == 'Male', 'Salary'].mean())
print('Female Directors:')
print(directors.loc[dat['Gender'] == 'Female', 'Salary'].mean())

print()



## EXTRAS

# female salaries with experience
ax = sns.lineplot(data=fem_dat, x = 'Years of Experience', y = 'Salary')
ax.set_title('Female Salaries with Experience')
ax.set_xlabel('Years of Experience')
ax.set_ylabel('Salaries')


# male salaries with experience
ax = sns.lineplot(data=male_dat, x = 'Years of Experience', y = 'Salary')
ax.set_title('Male Salaries with Experience')
ax.set_xlabel('Years of Experience')
ax.set_ylabel('Salaries')


# OLS Regression Female
fem_dat2 = fem_dat.copy()

fem_dat2['logsal'] = np.log2(fem_dat2['Salary'])

X = fem_dat2.loc[:,['Years of Experience']]
X = sm.add_constant(X)

y = fem_dat2['logsal']

modfit = sm.OLS(y, X).fit()
modfit.summary()


# OLS Regression Male
male_dat2 = male_dat.copy()

male_dat2['logsal'] = np.log2(male_dat2['Salary'])

X2 = male_dat2.loc[:,['Years of Experience']]
X2 = sm.add_constant(X2)

y2 = male_dat2['logsal']

modfit2 = sm.OLS(y2, X2).fit()
modfit2.summary()
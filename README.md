# Analyst Projects
- This repo holds all the projects for analyst portfolio.

# Content
1. [Data Exploration  - COVID 19 analysis](#data-exploration---covid-19-analysis)
2. [Data Visualization - COVID 19 analysis - Tableau Project](#data-visualization---covid-19-analysis---tableau-project)
3. [Data Cleaning  - Housing dataset](#data-cleaning---housing-dataset)
4. [Data Correlation  - Movies Correlation](#data-correlation---movies-correlation)
5. [Data Creation - Amazon Web Scraping](#data-creation---amazon-web-scraping)
6. [Data Visualization - AirBnB - Tableau Project](#data-visualization---airbnb---tableau-project)

# Data Exploration - COVID 19 analysis 
  - **Project Name**: [COVID analysis - Data exploration](https://github.com/Sunraj751/AnalystProjects/blob/main/Housing%20dataset%20-%20Data%20Cleaning%20.sql)
  - **Overview**:
    - Converted COVID 19 dataset to SQL Server
    - Did all sorts of data exploration using  SQL queries and some advanced concepts like using CTE's and Temp Tables.
  - **Functions used**: 
    - Joins, 
    - CTE's, 
    - Temp Table, 
    - Windows Functions, 
    - Aggregate functions, 
    - Creating Views, 
    - Converting Data types

# Data Visualization - COVID 19 analysis - Tableau Project
  - **Project Name**: [COVID Visualization - Tableau Queries](https://github.com/Sunraj751/AnalystProjects/blob/main/COVID%20Visualization%20-%20Tableau%20Queries.sql)
  - **Overview**:
    - The main focus for this project was visualizing using Tableau
    - This project uses the same dataset from COVID Analysis project.
    - It focuses on 4 main data points that i thought needed to be vizualized:
      - Global Number of cases, Death and Death Percentage (using table)
      - Total Deats per Continent (using graph)
      - Percentage of population infected in select countries (using graph)
      - Percent of population infected in the whole world (using map)
  - **Tableau Project View**: https://public.tableau.com/views/CovidWorldAnalysis_16714974078830/Dashboard1?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link 

# Data Cleaning - Housing dataset
  - **Project Name**: [Housing dataset - Data Cleaning](https://github.com/Sunraj751/AnalystProjects/blob/main/Housing%20dataset%20-%20Data%20Cleaning%20.sql)
  - **Overview**:
    - Used an excel file which had dataset for a housing project in Nashville
    - Scenario for this project was to clean the data for future use.
    - Followed a specific apporach (described in header comment in file) while approaching a the problems that needed to be delt with
  - **Functions used**
    - ISNULL(), 
    - JOIN, 
    - SUBSTRING,
    - PARSENAME, 
    - CASE statement, 
    - CTE, 
    - ROW_NUMBER, 
    - PARTITION BY 
    
# Data Correlation - Movies Correlation
  - **Project Name**: [Movies Correlation - Data Correlation](https://github.com/Sunraj751/AnalystProjects/blob/main/Movies%20Correlation%20-%20Data%20Correlation%20.ipynb)
  - **Overview**
    - Used python notebook in Jupyter
    - Reading the dataset about movies from Kaggle and using python and some libraries to find what effects Gross Revenue the most
  - **Libraries used**
    - pandas
    - numpy
    - seaborn
    - matplotlib
      - pyplot
      - mlab
  - **Graphs Created**
    - Scatter plot - matplotlib
    - Regression Plot - seaborn
  - **Correlations**
    - Correlation Matrix
      - Further pairing and sorting to find the answer to our main question
    - Visualizing the matrix 
    
# Data Creation - Amazon Web Scraping
  - **Project Name**: [Data Creation - Amazon Web Scraping](https://github.com/Sunraj751/AnalystProjects/blob/main/Dataset%20Creation%20-%20Amazon%20Web%20Scraping.ipynb)
  - **Overview**
    - Used python notebook in Jupyter
    - Connecting and Scrapping HTML from Amazon's product page and storing things into variable whilst cleaning it
    - Contains a script which automates the process to **run the data once every day and then stores the Name, Price and Date (the script ran) into an excel file**. Therefore creating a dataset for price fluctuation on a specific product over a period of time.
  - **Functions and Libraries Used**
    - BeautifulSoup
    - requests
    - time
    - datetime
    - csv
    - pandas

# Data Visualization - AirBnB - Tableau Project
- **Project Name**: [Data Visualization - AirBnB](https://public.tableau.com/app/profile/sunraj.sharma/viz/AirBnB-Toronto_16722716425580/Dashboard1?publish=yes)
- **Overview**
    - 5 Visualizations which are used to understand **which locality in Toronto** is best suited for buying a property for AirBnB rentals to **get gain profits**. 
    - It also shows if **Bedrooms** and **Months** have any correlation with **gaining higher profits** 
- **Dataset used** 
    - Downloaded the following from: http://insideairbnb.com/get-the-data/
        - Listings.csv
        - Calendar.csv
        - reviews.csv
- **Live Project Link**: https://public.tableau.com/app/profile/sunraj.sharma/viz/AirBnB-Toronto_16722716425580/Dashboard1?publish=yes

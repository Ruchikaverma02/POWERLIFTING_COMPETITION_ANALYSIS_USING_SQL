# 🏋️ Powerlifting Competition & Performance Analysis Using MySQL

## 📌 Project Overview

This project analyzes **Powerlifting Competition & Performance data using MySQL** to uncover patterns in athlete performance, competition participation, countries, equipment categories, divisions, and overall lifting performance.

The project is designed as a practical **Data Analytics / SQL portfolio project**, demonstrating how relational data can be queried and transformed into meaningful analytical insights.

The analysis contains **15 SQL questions** ranging from basic to advanced difficulty and demonstrates practical SQL concepts including:

- Data aggregation
- Filtering
- Sorting
- `GROUP BY`
- `HAVING`
- `INNER JOIN`
- Common Table Expressions (CTEs)
- Window functions
- `RANK()`
- `PARTITION BY`
- Calculated columns
- NULL-aware aggregation
- Group-level benchmarking
- One-to-many relationships

The project uses two related tables: `meets` and `powerlifting`. The `MeetID` column connects performance records to their corresponding competitions.

---

## 🎯 Project Objective

The primary objective of this project is to use SQL to analyze powerlifting competition and athlete performance data while demonstrating practical data-analysis techniques.

The analysis focuses on questions such as:

- How many competitions are present in the dataset?
- How many performance records are available?
- How are records distributed by sex?
- What is the average lifting total?
- What are the highest recorded performances?
- Which countries have the most performance records?
- How does performance vary by equipment?
- Which competitions contain the most performance records?
- What are the highest female performances?
- Which countries have higher average totals?
- What is the highest performance in each country?
- How can performances be ranked within groups?
- Which are the top performances within each equipment category?
- How does performance vary across divisions?
- Which performances are above their country's average?

---

## 🗃️ Dataset & Database

### Database

```sql
powerlifting_project
```

### Tables

The project uses two main tables:

### 1. `meets`

Contains information about powerlifting competitions.

Important fields include:

- `MeetID`
- `MeetName`
- `Date`
- `MeetCountry`

`MeetID` acts as the primary key for the competition table.

### 2. `powerlifting`

Contains individual athlete performance records.

Important fields include:

- `PerformanceID`
- `Name`
- `Sex`
- `BodyweightKg`
- `BestSquatKg`
- `BestBenchKg`
- `BestDeadliftKg`
- `TotalKg`
- `Equipment`
- `Division`
- `MeetID`

`MeetID` acts as the foreign key connecting each performance record to its competition.

### Relationship

```text
meets
  │
  │ MeetID
  │
  ▼
powerlifting
```

This represents a **one-to-many relationship**:

> One meet can contain many athlete performance records.

The SQL project explicitly uses this relationship when analyzing country-level and meet-level performance data.

---

## 📊 Dataset Scale

The cleaned dataset contains:

| Metric              |   Value |
| ------------------- | ------: |
| Meets               |   8,482 |
| Performance Records | 385,869 |
| SQL Questions       |      15 |

The project therefore provides a sufficiently large dataset for demonstrating practical SQL aggregation, joins, CTEs, and window-function techniques.

---

# 🔎 Analysis Performed

## 1. Competition Volume

Calculated the total number of meets in the `meets` table.

**Result:** 8,482 meets.

This establishes the overall scale of the competition dataset.

---

## 2. Performance Record Volume

Calculated the total number of athlete performance records.

**Result:** 385,869 performance records.

The difference between the number of meets and performance records demonstrates the one-to-many relationship between competitions and athlete performances.

---

## 3. Performance Records by Sex

Analyzed the distribution of performance records between male and female athletes.

| Sex    | Records |  Share |
| ------ | ------: | -----: |
| Male   | 298,622 | 77.39% |
| Female |  87,247 | 22.61% |

These percentages describe the composition of **this dataset only** and should not be interpreted as representing the entire powerlifting sport.

---

## 4. Average Total Performance

Calculated the average `TotalKg` across performance records while excluding NULL values.

This analysis demonstrates the use of:

```sql
AVG()
```

together with NULL-aware filtering.

---

## 5. Top 10 Performances by Total

Identified the 10 highest `TotalKg` performance records.

The analysis uses:

```sql
ORDER BY TotalKg DESC
LIMIT 10
```

The highest recorded performance in the analyzed dataset is **1,365.31 kg**, associated with Dave Hoff.

---

## 6. Performance Records by Country

Joined the `meets` and `powerlifting` tables to determine the number of performance records associated with each competition country.

The **USA** contains the largest number of performance records in this dataset, with **274,334 records**.

---

## 7. Average Total by Equipment

Compared average `TotalKg` across equipment categories.

The dataset shows the following descriptive averages:

| Equipment  | Average Total |
| ---------- | ------------: |
| Multi-ply  |     563.73 kg |
| Wraps      |     534.34 kg |
| Single-ply |     428.35 kg |
| Straps     |     388.21 kg |
| Raw        |     387.24 kg |

These are **descriptive differences within this dataset** and do not establish that equipment itself causes differences in performance. Other factors such as athlete strength, bodyweight, sex, division, competition, and time period can differ between groups.

---

## 8. Top 10 Meets by Number of Performance Records

Identified competitions containing the highest number of performance records.

The largest competition in this analysis is:

**Raw Nationals 2016**

- Meet ID: `7021`
- Date: `2016-10-13`
- Performance records: `1,197`

This analysis demonstrates aggregation across a one-to-many relationship.

---

## 9. Top 10 Female Performances

Filtered the dataset to female performance records and identified the 10 highest `TotalKg` values.

The highest female performance identified in the project is:

**Laura Phelps-Sweatt — 816.47 kg**

The analysis also demonstrates how filtering with `WHERE` occurs before sorting and limiting the final result.

---

## 10. Countries with Strong Average Totals

Calculated:

- Number of performance records
- Average `TotalKg`

for each country, while only including countries with at least **100 performance records**.

The query uses:

```sql
GROUP BY
HAVING
ORDER BY
```

The `HAVING` clause is particularly important because the minimum-record requirement is applied **after aggregation**.

---

## 11. Highest Performance in Each Country

Used a **Common Table Expression (CTE)** to calculate the maximum `TotalKg` for each country and then joined the result back to the detailed records.

The approach also handles ties correctly: if multiple athletes share the same country-level maximum, all tied records can be returned.

---

## 12. Ranking Performances Within Each Sex

Used the `RANK()` window function to rank performances separately for male and female records.

```sql
RANK() OVER (
    PARTITION BY Sex
    ORDER BY TotalKg DESC
)
```

This demonstrates how `PARTITION BY` creates independent ranking groups while retaining the individual performance rows.

The highest male and female records identified in the project are:

- Male: Dave Hoff — 1,365.31 kg
- Female: Laura Phelps-Sweatt — 816.47 kg

---

## 13. Top 3 Performances Within Each Equipment Type

Used:

```sql
RANK() OVER (
    PARTITION BY Equipment
    ORDER BY TotalKg DESC
)
```

to identify the highest-ranked performances within every equipment category.

Highest records identified include:

| Equipment  | Athlete           |       Total |
| ---------- | ----------------- | ----------: |
| Multi-ply  | Dave Hoff         | 1,365.31 kg |
| Raw        | Ray Williams      | 1,105.00 kg |
| Single-ply | Blaine Sumner     | 1,272.50 kg |
| Straps     | Yury Belkin       |   450.00 kg |
| Wraps      | Andrey Malanichev | 1,140.00 kg |

`RANK()` was used so tied values receive the same ranking.

---

## 14. Average Performance by Division

Compared divisions using:

- Number of performance records
- Average `TotalKg`
- Maximum `TotalKg`

Only divisions containing at least **50 performance records** were included.

This reduces the influence of very small groups and provides a more stable descriptive comparison.

---

## 15. Performance Above Country Average

Used a CTE to calculate the average `TotalKg` for each country and then compared every individual performance against its country's average.

The analysis calculates:

```text
DifferenceFromCountryAverage
=
Individual TotalKg - Country Average TotalKg
```

The largest positive difference identified is:

**Dave Hoff — USA**

- Total: 1,365.31 kg
- USA average: 431.02 kg
- Difference: 934.29 kg

This demonstrates **group-level benchmarking** using SQL.

---

# 💡 Key Insights

### Dataset Scale

The project analyzes:

- **8,482 meets**
- **385,869 performance records**

making it suitable for practical SQL analytics.

### Data Composition

Male records account for approximately **77.39%** of performance records, while female records account for approximately **22.61%**.

### Country Distribution

The USA contains the largest number of performance records, with **274,334 records**, showing that record volumes are highly uneven across countries.

### Equipment Differences

Multi-ply has the highest average `TotalKg` among the equipment categories analyzed.

These results are descriptive and should not be interpreted as causal evidence.

### Highest Recorded Performance

The highest recorded `TotalKg` identified in the project is **1,365.31 kg** by Dave Hoff.

### Window Function Analysis

`RANK()` enables performance records to be ranked independently within groups such as sex and equipment while retaining the underlying individual records.

### Time-Based Analysis

The dataset contains substantial variation in the number of meets and performance records across years. For example, 2017 contains **1,640 unique meets** and **108,576 performance records** in this dataset.

### Benchmarking

The project identifies performance records that exceed the average `TotalKg` of their respective country, demonstrating how SQL can be used for group-level benchmarking.

---

# 🧠 SQL Concepts Demonstrated

This project demonstrates the following SQL concepts:

- `SELECT`
- `WHERE`
- `COUNT()`
- `COUNT(DISTINCT)`
- `AVG()`
- `MAX()`
- `ORDER BY`
- `LIMIT`
- `GROUP BY`
- `HAVING`
- `INNER JOIN`
- Common Table Expressions (`CTE`)
- Window Functions
- `RANK()`
- `PARTITION BY`
- `YEAR()`
- Calculated Columns
- One-to-Many JOIN Logic
- Group-Level Benchmarking
- NULL-Aware Aggregation

---

# 🛠️ Tools & Technologies

| Tool                | Purpose                                   |
| ------------------- | ----------------------------------------- |
| **MySQL**           | Data querying and analysis                |
| **MySQL Workbench** | SQL development and execution             |
| **SQL**             | Data analysis and transformation          |
| **GitHub**          | Project documentation and version control |

---

# 📁 Project Structure

A recommended GitHub repository structure is:

```text
Powerlifting-Competition-Performance-Analysis/
│
├── README.md
│
├── Powerlifting Competition & Performance Analysis_Project.sql
│
├── Dataset/
│   ├── meets.csv
│   └── powerlifting.csv
```

---

# ▶️ How to Run the Project

### Step 1 — Install MySQL

Install **MySQL Server** and **MySQL Workbench**.

### Step 2 — Create / Select the Database

Use:

```sql
USE powerlifting_project;
```

### Step 3 — Load the Required Tables

Import or create the:

```text
meets
powerlifting
```

tables.

### Step 4 — Verify the Relationship

The tables should be connected using:

```text
meets.MeetID
       ↓
powerlifting.MeetID
```

### Step 5 — Execute the SQL Queries

Open the project SQL file in MySQL Workbench and execute the queries individually.

The project contains **15 analytical questions**, progressing from basic aggregation to joins, CTEs, window functions, and benchmarking.

---

# 📈 Business / Analytical Value

Although the dataset is based on sports performance, the SQL techniques demonstrated are directly applicable to real-world analytics.

The project demonstrates the ability to:

- Work with relational datasets
- Understand primary and foreign keys
- Combine data from multiple tables
- Aggregate large datasets
- Filter aggregated results
- Compare groups
- Rank records within categories
- Build reusable CTE-based analysis
- Create calculated metrics
- Benchmark individual records against group-level averages
- Handle NULL values appropriately

These are core capabilities expected in SQL-based data-analysis workflows.

---

# ⚠️ Important Analytical Considerations

The results in this project should be interpreted as **descriptive analysis of the supplied dataset**.

In particular:

- Country-level record counts do not necessarily represent the popularity of powerlifting in each country.
- Equipment-level averages do not establish causal relationships.
- Differences between divisions can reflect differences in sex, bodyweight, age, equipment, competition context, and other factors.
- The male/female distribution describes this dataset and should not be generalized to the entire sport.
- Small groups can produce unstable averages, which is why minimum-record thresholds are used in some analyses.

These limitations are important when converting SQL results into analytical conclusions.

---

# 🚀 Skills Demonstrated

Through this project, I demonstrated practical knowledge of:

**SQL Fundamentals**

- Filtering
- Sorting
- Aggregation
- Grouping

**Intermediate SQL**

- Multi-table joins
- `HAVING`
- Conditional filtering
- Calculated metrics
- NULL handling

**Advanced SQL**

- Common Table Expressions
- Window functions
- `RANK()`
- `PARTITION BY`
- Group-level benchmarking
- Top-N analysis within groups

---

# 👤 Author

**Ruchika Verma**

**Role:** Data Analyst

**Project:** Powerlifting Competition & Performance Analysis Using MySQL

**Database:** `powerlifting_project`

**SQL Questions:** 15

**Difficulty:** Basic → Intermediate → Advanced

---

# ⭐ Conclusion

This project demonstrates how MySQL can be used to transform a large relational powerlifting dataset into meaningful analytical insights.

Starting with basic aggregation and filtering, the analysis progresses into multi-table joins, grouped comparisons, CTEs, window functions, ranking, and group-level benchmarking.

The project therefore serves as a practical demonstration of SQL skills required for **data analysis and entry-level data analyst workflows**.

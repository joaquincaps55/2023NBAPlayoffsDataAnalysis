# 2023 NBA Playoffs Data Analysis and Visualization

## Project Overview

This project focuses on analyzing data from the 2023 NBA Playoffs. The analysis includes SQL queries to extract insights and Power BI dashboards to visualize the findings. The data used in this project was sourced from [Kaggle](https://www.kaggle.com/datasets/nasifulchoudhury/2023-nba-playoffs-stats). The original dataset was processed and split into two reports: one for player statistics and another for team statistics.

As a lifelong Denver Nuggets fan, this analysis is especially meaningful to me. I've been following the Nuggets since I was a kid, making this project a bit more personal as I dive into the performance of my favorite team.

## Table of Contents

1. [Project Description](#project-description)
2. [Tools and Technologies](#tools-and-technologies)
3. [Project Story](#project-story)
4. [SQL Queries](#sql-queries)
   - [Database Structure](#database-structure)
   - [SQL Queries](#sql-queries-list)
5. [Power BI Dashboard](#power-bi-dashboard)
   - [Visualizations](#visualizations)
   - [Instructions to View the Dashboard](#instructions-to-view-the-dashboard)
6. [How to Use This Project](#how-to-use-this-project)
7. [Contact](#contact)
8. [License](#license)

## Project Description

This project focuses on analyzing NBA 2023 Playoff data, highlighting player and team performance through SQL queries and interactive Power BI dashboards. The data is analyzed to uncover insights such as top scorers, team contributions, and player efficiency. The Power BI dashboard offers a visual summary of the findings, allowing for an intuitive understanding of the data.

### Data Source

The data for this project was sourced from Kaggle, a well-known platform for datasets and data science projects. You can access the original dataset [here](https://www.kaggle.com/datasets/nasifulchoudhury/2023-nba-playoffs-stats). The original dataset was processed and split into two new reports to focus on player statistics and team statistics separately, making it easier to analyze and visualize the data.

## Tools and Technologies

- **SQL:** MySQL for querying and analyzing the data.
- **Power BI:** For data visualization and creating interactive dashboards.
- **GitHub:** For version control and sharing the project.

## Project Story

### Background and Motivation

The NBA Playoffs are one of the most exciting times in sports, with players pushing their limits and teams strategizing to win the championship. As a lifelong fan of the Denver Nuggets, a team I've been following since childhood, this project holds personal significance. The Nuggets have always been my favorite team, and analyzing the NBA Playoff data, especially with a focus on the Nuggets, allows me to combine my passion for basketball with my skills in data analysis.

### Problem Statement

The objective was to analyze the NBA 2023 Playoff data to identify top-performing players, understand how individual performances contributed to team success, and highlight key metrics that indicate a player's impact on the game. The challenge was to handle a large dataset, process it effectively using SQL, and then visualize the findings in an interactive and easily interpretable format using Power BI.

### Solution

I developed a series of SQL queries to dissect the playoff data, focusing on various aspects of player and team performance. These queries were then connected to Power BI, where I designed a dashboard that tells the story of the playoffs from different angles. The result is a comprehensive analysis that provides deep insights into the factors that contribute to success in the NBA Playoffs, with a special nod to my beloved Denver Nuggets.

## SQL Queries

### Database Structure

The database used for this project consists of two main tables:

1. **player_stats:** Contains individual player statistics, including points, assists, rebounds, and other key performance metrics.
2. **team_stats:** Contains aggregated team statistics, including total points and average points per game.

### SQL Queries List

Below are the SQL queries used to analyze the NBA 2023 Playoff data:

1. **Top 10 Players PPG (Points Per Game):**
   ```sql
   SELECT player_name, average_pts
   FROM player_stats
   ORDER BY average_pts DESC
   LIMIT 10;
   ```

2. **Top 10 Players All Around Performance (Points, Assists, and Rebounds):**
   ```sql
   SELECT player_name, average_pts, average_ast, tot_reb_pct, 
          (average_pts + average_ast + tot_reb_pct) AS total_performance
   FROM player_stats
   ORDER BY total_performance DESC
   LIMIT 10;
   ```

3. **Aggregating Player Data at Team Level:**
   ```sql
   SELECT player_tm, COUNT(player_name) AS total_players, 
          SUM(average_pts * gms_played) AS total_points, 
          AVG(average_pts) AS avg_points_per_game
   FROM player_stats
   GROUP BY player_tm
   ORDER BY total_points DESC;
   ```

4. **Player Efficiency Score Calculation:**
   ```sql
   SELECT player_name, player_tm, 
          (average_pts + average_ast + average_stl + average_blk + tot_reb_pct * 0.5 
          - (average_tov + average_pf)) AS player_efficiency
   FROM player_stats
   WHERE gms_played > 10
   ORDER BY player_efficiency DESC
   LIMIT 10;
   ```

5. **Top 5 Performing Players (One from Each Team):**
   ```sql
   WITH RankedPlayers AS (
       SELECT p.player_name, p.player_tm, p.average_pts, t.average_pts AS team_avg_pts,
              ROW_NUMBER() OVER (PARTITION BY p.player_tm ORDER BY p.average_pts DESC) AS rn
       FROM player_stats p
       JOIN (
           SELECT nba_team, average_pts
           FROM team_stats
           ORDER BY average_pts DESC
           LIMIT 10
       ) AS t ON p.player_tm = t.nba_team
       WHERE p.gms_played > 10
   )
   SELECT player_name, player_tm, average_pts, team_avg_pts
   FROM RankedPlayers
   WHERE rn = 1
   ORDER BY average_pts DESC
   LIMIT 5;
   ```

6. **Defensive Impact Analysis:**
   ```sql
   SELECT player_name, player_tm, average_stl, average_blk, tot_reb_pct AS average_def_reb,
          (average_stl + average_blk + tot_reb_pct * 0.5) AS defensive_impact
   FROM player_stats
   WHERE gms_played > 10
   ORDER BY defensive_impact DESC
   LIMIT 10;
   ```

7. **Clutch Performance Analysis:**
   ```sql
   SELECT player_name, player_tm, 
          SUM(CASE WHEN mins_played > (gms_played * 0.75) THEN average_pts ELSE 0 END) AS clutch_points
   FROM player_stats
   WHERE gms_played > 10
   GROUP BY player_name, player_tm
   ORDER BY clutch_points DESC
   LIMIT 10;
   ```

8. **Individual Player Contribution to Team Performance:**
   ```sql
   SELECT p.player_name, p.player_tm, p.average_pts, t.average_pts AS team_avg_pts
   FROM player_stats p
   JOIN team_stats t ON p.player_tm = t.nba_team
   ORDER BY p.average_pts DESC;
   ```

## Power BI Dashboard

### Visualizations

The Power BI dashboard visualizes the results of the SQL queries through the following visualizations:

1. **Top 10 Scorers in NBA Playoffs 2023 (Bar Chart):**
   - Displays the top 10 players based on their points per game.

2. **Top Players by Efficiency Score (Table):**
   - Lists players based on their efficiency score, calculated from multiple performance metrics.

3. **Team Performance Contribution by Player (Stacked Bar Chart):**
   - Visualizes how individual players contribute to their team’s total points.

4. **Clutch Performance Analysis (Line Chart):**
   - Shows player performance in clutch situations (when they played more than 75% of game time).

### Instructions to View the Dashboard

1. **Download the `.pbix` file** from this repository.
2. **Open the file in Power BI Desktop**.
3. **Explore the visualizations** and interact with the dashboard to gain insights into player and team performances during the NBA Playoffs 2023.

## How to Use This Project

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/joaquincaps55/2023NBAPlayoffsDataAnalysis.git
   ```
   
2. **Set Up the SQL Database:**
   - Import the `nba_playoffs.sql` file to set up the database.
   - If the SQL file does not automatically import the data, manually import the CSV files (`NBA 2023 Playoff Data Analysis - Player Stats.csv` and `NBA 2023 Playoff Data Analysis - Team Data.csv`) into their respective tables.

3. **View the Power BI Dashboard:**
   - Download and open the `.pbix` file in Power BI Desktop to view the visualizations.

## **Contact**

For any questions or suggestions, feel free to reach out via email - joaquincapinpuyan@yahoo.co.uk or connect with me on LinkedIn - https://www.linkedin.com/in/joaquin-capinpuyan-863235175

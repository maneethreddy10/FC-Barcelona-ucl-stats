##FC-Barcelona-ucl-stats
I HAVE CREATED A SMALL ANALYSIS ON THE BARCA PLAYERS 24/25 UCL PERFORMANCES IT IS NOT A DETAILED ANALYSIS 
 Barcelona Player Stats Analysis 🏟️📊

**FC Barcelona 2024–25 player performance analysis using PostgreSQL.**  
Explore player efficiency, positional trends, penalty accuracy, discipline stats, and more using SQL.

---

📋 Project Structure

barca-player-stats-analysis/
├── barca_player_stats.csv
├── schema.sql
├── analysis_queries.sql
└── README.md

markdown
Copy
Edit

- `barca_player_stats.csv`: Raw player data  
- `schema.sql`: Table creation script  
- `analysis_queries.sql`: All example SQL queries  
- `README.md`: This documentation  

---

## 🧾 Dataset Description

File: **`barca_player_stats.csv`**

Each row represents a player and includes:

| Column                         | Description                             |
|-------------------------------|-----------------------------------------|
| `player`                      | Player name                             |
| `position`                    | Playing position (e.g. FW, MF, DF)      |
| `current_age`                 | Age in years                            |
| `matches_played`, `starts`    | Number of matches and starts            |
| `minutes`                     | Total playing time                      |
| `goals`, `assists`            | Offensive contributions                 |
| `goals_assists`              | Sum of goals and assists                |
| `non_penalty_goals`           | Goals scored excluding penalties         |
| `penalty_kicks_made`, `penalty_kicks_attempted` | Penalty performance metrics |
| `yellow_cards`, `red_cards`   | Discipline statistics                    |

---

## ⚙️ Setup Instructions

### 1. Create PostgreSQL Table

Use the script `schema.sql`:

```sql
CREATE TABLE barca_player_stats (
  player TEXT,
  position TEXT,
  current_age NUMERIC,
  matches_played INTEGER,
  starts INTEGER,
  minutes INTEGER,
  goals INTEGER,
  assists INTEGER,
  goals_assists INTEGER,
  non_penalty_goals INTEGER,
  penalty_kicks_made INTEGER,
  penalty_kicks_attempted INTEGER,
  yellow_cards INTEGER,
  red_cards INTEGER
);
2. Import CSV Data
Using psql:

sql
Copy
Edit
\copy barca_player_stats FROM 'path/to/barca_player_stats.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
Using pgAdmin:

Right-click barca_player_stats table → Import/Export

Choose CSV file, ensure header row and UTF‑8 encoding, and import

🔎 Analysis Queries
All queries are saved in analysis_queries.sql. Here’s a summary:


1. Top contributors per 90 minutes
SELECT player,
       ROUND((goals + assists)::numeric / minutes * 90, 2) AS contrib_per_90
FROM barca_player_stats
WHERE minutes > 0
ORDER BY contrib_per_90 DESC
LIMIT 10;



2. Penalty Conversion Rate
SELECT player,
       penalty_kicks_attempted,
       ROUND(
         penalty_kicks_made::numeric /
         NULLIF(penalty_kicks_attempted, 0) * 100, 2
       ) AS penalty_pct
FROM barca_player_stats
WHERE penalty_kicks_attempted > 0
ORDER BY penalty_pct DESC;


3. Goals & Assists by Position
SELECT position,
       ROUND(AVG(goals), 2) AS avg_goals,
       ROUND(AVG(assists), 2) AS avg_assists
FROM barca_player_stats
GROUP BY position
ORDER BY avg_goals DESC;



4. High Minutes, Zero Contribution
SELECT player, minutes, (goals + assists) AS total_contrib
FROM barca_player_stats
WHERE minutes > 800 AND (goals + assists) = 0
ORDER BY minutes DESC;



5. Positional Contribution Efficiency
SELECT position,
       ROUND(AVG((goals + assists)::numeric / minutes * 90), 2) AS avg_contrib_90
FROM barca_player_stats
WHERE minutes > 0
GROUP BY position
ORDER BY avg_contrib_90 DESC;



6. Players Above Team Average Contribution
WITH overall AS (
  SELECT AVG((goals + assists)::numeric / minutes * 90) AS avg_contrib_90
  FROM barca_player_stats
  WHERE minutes > 0
)
SELECT player, position,
       ROUND((goals + assists)::numeric / minutes * 90, 2) AS contrib_90
FROM barca_player_stats, overall
WHERE minutes > 600
  AND (goals + assists)::numeric / minutes * 90 > overall.avg_contrib_90
ORDER BY contrib_90 DESC;



7. Assists per 90 minutes
SELECT player,
       ROUND(assists::numeric / minutes * 90, 2) AS assists_per_90
FROM barca_player_stats
WHERE minutes > 0
ORDER BY assists_per_90 DESC
LIMIT 10;



8. Average Age by Position
SELECT position,
       ROUND(AVG(current_age), 2) AS avg_age,
       COUNT(*) AS num_players
FROM barca_player_stats
GROUP BY position
ORDER BY avg_age;




9. Cards per 90 minutes
SELECT player,
       ROUND((yellow_cards + red_cards)::numeric / minutes * 90, 3) AS cards_per_90
FROM barca_player_stats
WHERE minutes > 0
ORDER BY cards_per_90 DESC
LIMIT 10;


10. Lowest Penalty Conversion (≥ 5 attempts)
SELECT player,
       penalty_kicks_attempted,
       ROUND(
         penalty_kicks_made::numeric /
         NULLIF(penalty_kicks_attempted, 0) * 100, 2
       ) AS penalty_pct
FROM barca_player_stats
WHERE penalty_kicks_attempted >= 5
ORDER BY penalty_pct ASC
LIMIT 10;


🎯 Project Highlights
This repository demonstrates:

Per 90-minute normalization for fair comparison

Positional efficiency and age patterns

Discipline and penalty-taking consistency

Identification of both standout and underperforming players

Ideal for data analyst portfolios or football analytics showcases.


--TABLE CREATION
drop table if exists barca_player_stats;
create table barca_player_stats(
Player	varchar(50),
Nation	varchar(50),
Position varchar(50),
Current_age	int,
Matches_Played	int,
Starts	int,
Minutes	int,
Ninetys_Played	float,
Goals	int,
Assists	int,
Goals_Assists int,
Non_Penalty_Goals int,
Penalty_Kicks_Made int,
Penalty_Kicks_Attempted int,	
Yellow_Cards	int,
Red_Cards int

);
--DATA INSERTION
COPY barca_player_stats(
  Player, Nation, Position, Current_age, Matches_Played, Starts,
  Minutes, Ninetys_Played, Goals, Assists, Goals_Assists,
  Non_Penalty_Goals, Penalty_Kicks_Made, Penalty_Kicks_Attempted,
  Yellow_Cards, Red_Cards
)
FROM 'C:/Users/Maneeth/OneDrive/Desktop/Standard_Stats_2024-2025_Barcelona__Champions_League.csv'
DELIMITER ','
CSV HEADER;
select * from barca_player_stats


--DATA CLEANING
select * from barca_player_stats
where Nation is null
or
Position is null
or
Current_age is null
or
Matches_Played is null
or
Starts is null 
or
Minutes is null
or
Ninetys_Played is null
or
Goals is null
or
Assists is null
or
Goals_Assists is null
or
Non_Penalty_Goals is null
or
Penalty_Kicks_Made is null
or 
Penalty_Kicks_Attempted is null	
or
Yellow_Cards is null
or
Red_Cards is null

delete from barca_player_stats 
where Nation is null
or
Position is null
or
Current_age is null
or
Matches_Played is null
or
Starts is null 
or
Minutes is null
or
Ninetys_Played is null
or
Goals is null
or
Assists is null
or
Goals_Assists is null
or
Non_Penalty_Goals is null
or
Penalty_Kicks_Made is null
or 
Penalty_Kicks_Attempted is null	
or
Yellow_Cards is null
or
Red_Cards is null

--DATA EXPLORATION
--HOW MANY PLAYER HAS BARCELONA REGISTERED?
select count(*) from barca_player_stats

--DATA ANALYSIS
-- DISPLAY THE COUNT AND PLAYERS WHO ARE FROM SPAIN IN THE TEAM.
select * from barca_player_stats 
where nation= 'es ESP'
select COUNT(*) from barca_player_stats 
where nation= 'es ESP'
--DISPLAY ALL THE DEFENDERS FROM THE TEAM
select * from barca_player_stats 
where position ='DF'
--Which top 10 players have the highest goal contributions (Goals + Assists) per 90 minutes ?
SELECT
  player,
  ROUND((goals + assists)::numeric / minutes * 90, 2) as contributions_per_90
FROM barca_player_stats
ORDER BY contributions_per_90 DESC
LIMIT 10;

--Which players played the most minutes but scored zero goals or assists?
select * from barca_player_stats
where goals_assists = 0
order by minutes desc

-- Which players scored the most penalties? (i.e., % of penalties scored)
select
  player,
  Penalty_Kicks_Made,
  Penalty_Kicks_Attempted,
  ROUND(Penalty_Kicks_Made::numeric / nullif (Penalty_Kicks_Attempted, 2) * 100, 2) AS penalty_conversion_percent
from barca_player_stats
where Penalty_Kicks_Attempted > 0
ORDER BY penalty_conversion_percent ASC
LIMIT 10;


--What is the average Goals and Assists for each player position?
SELECT
  Position,
  ROUND(AVG(Goals_Assists), 2) AS avg_goals_assists,
  STRING_AGG(Player, ', ' ORDER BY Goals DESC) AS players_in_position
FROM barca_player_stats
GROUP BY Position
ORDER BY avg_goals_assists DESC;

--List all the player and their personals goals and assists
select player,nation,position,goals,assists from barca_player_stats
order by goals_assists desc

--What is the average age by position?
select position, round(avg(current_age),2) as avg_age
from barca_player_stats
group by position
order by position desc

--Which players struggled offensively despite high minutes?
SELECT player, minutes, goals + assists AS total_contrib
FROM barca_player_stats
WHERE minutes > 800 AND goals + assists < 5
ORDER BY minutes DESC;

--Which players have the highest cards per 90 minutes?
select player, position, round((yellow_cards + red_cards / minutes * 90),2) as highest_cards from barca_player_stats
group by position,player,yellow_cards, red_cards, minutes, ninetys_played
order by highest_cards desc
limit 10

--Which players are overperforming relative to playing time? (Players with above average contributions per 90 among those playing at least 600 minutes.)
WITH overall AS (
  SELECT AVG((goals + assists)::numeric / minutes * 90) AS avg_contrib_90
  FROM barca_player_stats
  WHERE minutes > 0
)
SELECT
  player,
  position,
  ROUND((goals + assists)::numeric / minutes * 90, 2) AS contrib_90
FROM
  barca_player_stats,
  overall
WHERE
  minutes > 600
  AND (goals + assists)::numeric / minutes * 90 > overall.avg_contrib_90
ORDER BY contrib_90 DESC;
--THE END

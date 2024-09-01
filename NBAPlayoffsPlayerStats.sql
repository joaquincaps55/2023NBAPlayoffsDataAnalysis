SELECT * FROM nba_playoffs.player_stats;

-- Top 10 Players PPG (Points Per Game)
SELECT player_name, average_pts
FROM player_stats
ORDER BY average_pts DESC
LIMIT 10;

-- Top 10 Players All Around Performance (points, assists and rebounds)
SELECT player_name, average_pts, average_ast, tot_reb_pct, (average_pts + average_ast + tot_reb_pct) AS total_performance
FROM player_stats
ORDER BY total_performance DESC
LIMIT 10;

-- Aggregating player data at team level, calculating points and average points per game
SELECT player_tm, COUNT(player_name) AS total_players, 
       SUM(average_pts * gms_played) AS total_points, 
       AVG(average_pts) AS avg_points_per_game
FROM player_stats
GROUP BY player_tm
ORDER BY total_points DESC;

-- Calculate a metric that combines various statistics into a single efficiency score, giving a quick overview of a player’s overall contribution.
SELECT player_name, player_tm, 
       (average_pts + average_ast + average_stl + average_blk + tot_reb_pct * 0.5 
       - (average_tov + average_pf)) AS player_efficiency
FROM player_stats
WHERE gms_played > 10
ORDER BY player_efficiency DESC
LIMIT 10;

-- Identify the top 5 performing players, each from a different team, based on their average points per game.
WITH RankedPlayers AS (
    SELECT p.player_name, p.player_tm, p.average_pts, t.average_pts AS team_avg_pts,
           ROW_NUMBER() OVER (PARTITION BY p.player_tm ORDER BY p.average_pts DESC) AS rn
    FROM player_stats p
    JOIN (
        SELECT nba_team, average_pts
        FROM team_stats
        ORDER BY average_pts DESC
        LIMIT 10  -- Consider more teams in case some teams have fewer eligible players
    ) AS t ON p.player_tm = t.nba_team
    WHERE p.gms_played > 10  -- Only include players with more than 10 games
)
SELECT player_name, player_tm, average_pts, team_avg_pts
FROM RankedPlayers
WHERE rn = 1
ORDER BY average_pts DESC
LIMIT 5;

-- Defensive Impact Analysis
SELECT player_name, player_tm, average_stl, average_blk, tot_reb_pct AS average_def_reb,
       (average_stl + average_blk + tot_reb_pct * 0.5) AS defensive_impact
FROM player_stats
WHERE gms_played > 10
ORDER BY defensive_impact DESC
LIMIT 10;

-- Clutch Perfomance Analysis
SELECT player_name, player_tm, 
       SUM(CASE WHEN mins_played > (gms_played * 0.75) THEN average_pts ELSE 0 END) AS clutch_points
FROM player_stats
WHERE gms_played > 10
GROUP BY player_name, player_tm
ORDER BY clutch_points DESC
LIMIT 10;

-- Analysis of how an individual player perfomance contributed to their team's average
SELECT p.player_name, p.player_tm, p.average_pts, t.average_pts AS team_avg_pts
FROM player_stats p
JOIN team_stats t ON p.player_tm = t.nba_team
ORDER BY p.average_pts DESC;

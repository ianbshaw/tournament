-- Table definitions for the tournament project.

-- Create clean database and connect
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament


-- Table Creations
CREATE TABLE Players (
	PlayerID serial PRIMARY KEY,
	name TEXT
);
CREATE TABLE Matches (
	MatchID serial PRIMARY KEY,
	Winner int REFERENCES Players(PlayerID) ON DELETE CASCADE,
	Loser int REFERENCES Players(PlayerID) ON DELETE CASCADE,
	CHECK (Winner <> Loser)
);

-- View to calculate number of wins
CREATE VIEW v_wins AS
	SELECT a.PlayerID, count(b.Winner) AS wins
    FROM Players a
    LEFT JOIN Matches b 
    ON a.PlayerID=b.Winner
    GROUP BY a.PlayerID
    ORDER BY a.PlayerID;

-- View to calculate number of matches played
CREATE VIEW v_matches AS
	SELECT a.PlayerID, count(b.*) AS matches
	FROM Players a 
	LEFT OUTER JOIN Matches b ON 
	a.PlayerID = b.Winner OR a.PlayerID = b.Loser
	GROUP BY a.PlayerID
	ORDER BY a.PlayerID;

-- View to create standings including PlayerID, Name, # of wins, # of matches played sorted by wins
CREATE VIEW v_standings AS
	SELECT a.PlayerID, 
		   a.name, 
		   b.wins, 
		   c.matches 
	FROM Players a 
	LEFT OUTER JOIN v_wins b ON 
	a.PlayerID = b.PlayerID
	LEFT OUTER JOIN v_matches c ON
	a.PlayerID = c.PlayerID
	ORDER BY b.wins DESC, a.PlayerID;

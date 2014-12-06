CREATE VIEW getPrecipitationView AS
	SELECT State.statecode, Month.monthname AS [month], Year.yearname AS [year], Weather.pcp
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.SID = State.id
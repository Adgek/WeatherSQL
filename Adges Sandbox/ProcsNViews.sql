BEGIN
CREATE VIEW getPrecipitationView AS
	SELECT State.statecode, Month.monthname AS [month], Year.yearname AS [year], Weather.pcp
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.SID = State.id
END;
GO

BEGIN
-- Cooling heating days
CREATE VIEW getCoolAndHeatView AS
	SELECT State.statecode, Month.monthname AS [month], Year.yearname AS [year], Weather.cdd, Weather.hdd
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.SID = State.id
END;
GO

BEGIN
-- Temperature
CREATE VIEW getTemperatureView AS
	SELECT State.statecode, Month.monthname AS [month], Year.yearname AS [year], Weather.Tmin, Weather.Tmax, Weather.Tavg
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.SID = State.id
END;
GO

BEGIN
CREATE PROCEDURE getPrecipitationForArea @AreaCode int
AS
SELECT [month], [year], pcp
FROM getPrecipitationView
WHERE statecode = @AreaCode
ORDER BY [year],[month]
END;
GO

BEGIN
CREATE PROCEDURE getCoolAndHeatForArea @AreaCode int
AS
SELECT  [month], [year], cdd, hdd
FROM getCoolAndHeatView
WHERE statecode = @AreaCode
ORDER BY [year],[month]
END;
GO

BEGIN
CREATE PROCEDURE getPrecipitationForArea @AreaCode int
AS
SELECT [month], [year], Tmin, Tmax, Tavg
FROM getTemperatureView
WHERE statecode = @AreaCode
ORDER BY [year],[month]
END;
GO
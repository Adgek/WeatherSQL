#*******************
#VIEWS
#*******************
CREATE OR REPLACE VIEW getPrecipitationView AS
	SELECT State.statecode, Month.monthname, Year.yearname, Weather.pcp
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.DID = State.id
	ORDER BY Year.yearname, Month.monthname

-- Cooling heating days
CREATE OR REPLACE VIEW getCoolAndHeatView AS
	SELECT State.statecode, Month.monthname, Year.yearname, Weather.cdd, Weather.hdd
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.DID = State.id
	ORDER BY Year.yearname, Month.monthname

-- Temperature
CREATE OR REPLACE VIEW getTemperatureView AS
	SELECT State.statecode, Month.monthname, Year.yearname, Weather.Tmin, Weather.Tmax, Weather.Tavg
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.DID = State.id
	ORDER BY Year.yearname, Month.monthname


#**********************
#Stored Procedures
#**********************
CREATE PROCEDURE getPrecipitationForArea @AreaCode int
AS
SELECT * 
FROM getPrecipitationView
WHERE State.statecode = @AreaCode
GO

CREATE PROCEDURE getCoolAndHeatForArea @AreaCode int
AS
SELECT * 
FROM getCoolAndHeatView
WHERE State.statecode = @AreaCode
GO

CREATE PROCEDURE getPrecipitationForArea @AreaCode int
AS
SELECT * 
FROM getTemperatureView
WHERE State.statecode = @AreaCode
GO
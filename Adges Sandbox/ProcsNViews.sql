-- Precipition
-- 	year
-- 	month
--	area
-- 	precipition amount

#*******************
#VIEWS
#*******************
CREATE OR REPLACE VIEW getPrecipitationView AS
	SELECT State.statecode, Month.monthname, Year.yearname, Weather.pcp
	FROM Weather
	INNER JOIN Year on Weather.YID = Year.id
	INNER JOIN Month on Weather.MID = Month.id
	INNER JOIN State on Weather.DID = State.id
	ORDER BY Year.yearname, Month.monthname;
-- Cooling heating days

-- Temperature



#**********************
#Stored Procedures
#**********************
CREATE PROCEDURE getPrecipitationForYear @Year nvarchar(4)
AS
SELECT * 
FROM getPrecipitationView
WHERE Year.yearname = @Year
GO
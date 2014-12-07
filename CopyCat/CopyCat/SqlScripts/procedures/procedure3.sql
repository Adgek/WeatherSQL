CREATE PROCEDURE getTemperatureForArea @AreaCode int
AS
SELECT [month], [year], Tmin, Tmax, Tavg
FROM getTemperatureView
WHERE statecode = @AreaCode
ORDER BY [year],[month]
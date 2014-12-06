CREATE PROCEDURE getCoolAndHeatForArea @AreaCode int
AS
SELECT  [month], [year], cdd, hdd
FROM getCoolAndHeatView
WHERE statecode = @AreaCode
ORDER BY [year],[month]
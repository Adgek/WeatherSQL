CREATE PROCEDURE getPrecipitationForArea @AreaCode int
AS
SELECT [month], [year], pcp
FROM getPrecipitationView
WHERE statecode = @AreaCode
ORDER BY [year],[month]

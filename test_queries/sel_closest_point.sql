SELECT
	"name",
	way <-> 'SRID=4326; POINT(36.576533 50.600000)'::geometry AS dist,
	way
FROM
	public.planet_osm_point
ORDER BY
	dist
LIMIT 1

-- Запрос для получения ближайшей к точке точки на карте
-- Больше информации о точках: https://wiki.openstreetmap.org/wiki/Node
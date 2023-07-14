SELECT
	"name",
	way <-> 'SRID=4326; POINT(36.576533 50.600000)'::geometry AS dist,
	way
FROM
	public.planet_osm_line
ORDER BY
	dist
LIMIT 1

-- Запрос для получения ближайшей к точке линии на карте
-- Больше информации о линиях: https://wiki.openstreetmap.org/wiki/Way
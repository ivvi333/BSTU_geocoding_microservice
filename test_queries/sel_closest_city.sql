SELECT
	place,
	"name",
	population,
	way <-> 'SRID=4326; POINT(36.576533 50.600000)'::geometry AS dist,
	way
FROM
	public.planet_osm_point
WHERE
	place = 'city'
ORDER BY
	dist
LIMIT 1

-- Запрос для получения ближайшего к точке города (точки)
-- Больше информации о тегах: https://wiki.openstreetmap.org/wiki/RU:Key:place
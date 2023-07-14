SELECT
	"addr:street",
	"addr:housenumber",
	way <-> 'SRID=4326; POINT(36.576533 50.600000)'::geometry AS dist,
	way
FROM
	public.planet_osm_polygon
WHERE
	"addr:street" IS NOT null AND
	"addr:housenumber" IS NOT null
ORDER BY
	dist
LIMIT 1

-- Запрос для получения ближайшего к точке здания (многоугольника)
-- Больше информации о тегах: https://wiki.openstreetmap.org/wiki/RU:Key:addr:*
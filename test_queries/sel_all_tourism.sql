SELECT
	"name",
	way
FROM
	public.planet_osm_point
WHERE
	tourism IS NOT null
UNION
SELECT
	"name",
	way
FROM
	public.planet_osm_polygon
WHERE
	tourism IS NOT null

-- Запрос для получения всех объектов, представляющих интерес для туристов
-- Больше информации о тегах: https://wiki.openstreetmap.org/wiki/RU:Key:tourism
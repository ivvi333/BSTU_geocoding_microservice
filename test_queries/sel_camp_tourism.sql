SELECT
	"name",
	way
FROM
	public.planet_osm_point
WHERE
	tourism = 'camp_pitch' OR
	tourism = 'camp_site' OR
	tourism = 'caravan_site'
UNION
SELECT
	"name",
	way
FROM
	public.planet_osm_polygon
WHERE
	tourism = 'camp_pitch' OR
	tourism = 'camp_site' OR
	tourism = 'caravan_site'

-- Запрос для получения объектов кемпинга
-- camp_pitch - место для палатки или дома на колёсах на территории лагеря или кемпинга
-- camp_site - кемпинг, палаточный городок
-- caravan_site - место, где вы можете остаться в доме на колёсах на ночь или на более длительный период
-- Больше информации о тегах: https://wiki.openstreetmap.org/wiki/RU:Key:tourism
SELECT
    *
FROM
    public.planet_osm_point
WHERE
    planet_osm_point ==>
    dsl.geo_shape(
        'way',
        '{
            "type": "envelope",
            "coordinates": [ [36.5763, 50.6005], [36.5766, 50.6] ]
        }',
        'WITHIN'
    )

-- Тестовый запрос с использованием ZomboDB и функции dsl.geo_shape
-- https://github.com/zombodb/zombodb/blob/master/QUERY-BUILDER-API.md#dslgeo_shape
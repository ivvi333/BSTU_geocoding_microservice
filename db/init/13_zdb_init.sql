CREATE EXTENSION zombodb;

CREATE INDEX idxline
ON public.planet_osm_line
USING zombodb ((public.planet_osm_line.*))
WITH (url='http://es01:9200/');

CREATE INDEX idxpoint
ON public.planet_osm_point
USING zombodb ((public.planet_osm_point.*))
WITH (url='http://es01:9200/');

CREATE INDEX idxpolygon
ON public.planet_osm_polygon
USING zombodb ((public.planet_osm_polygon.*))
WITH (url='http://es01:9200/');

CREATE INDEX idxroads
ON public.planet_osm_roads
USING zombodb ((public.planet_osm_roads.*))
WITH (url='http://es01:9200/');
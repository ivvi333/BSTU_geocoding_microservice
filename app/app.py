import json
import os
import re
from collections import OrderedDict

from flask import Flask, request, abort
from geoalchemy2 import Geometry, Geography
from sqlalchemy import create_engine, MetaData, select, func, text

app = Flask(__name__)
app.json.ensure_ascii = False

db_user = os.environ.get('DB_USER')
db_pass = os.environ.get('DB_PASS')
db_host = os.environ.get('DB_HOST')
db_name = os.environ.get('DB_NAME')
engine = create_engine(f'postgresql://{db_user}:{db_pass}@{db_host}/{db_name}', client_encoding='utf-8')

metadata_obj = MetaData()
metadata_obj.reflect(bind=engine)

lines = metadata_obj.tables['planet_osm_line']
points = metadata_obj.tables['planet_osm_point']
polygons = metadata_obj.tables['planet_osm_polygon']
roads = metadata_obj.tables['planet_osm_roads']


# Возвращает координаты полигона, ближайшего к указанному в строке запросов адресу
@app.get('/api/search')
def search_area():
    # Предполагаем, что аргумент addr содержит адрес в нужном формате (указан ниже)
    addr = request.args.get('addr', None)
    if addr is None:
        abort(404)

    # Regex для парсинга адреса формата "<г. Город>[,]<ул. Название улицы>[,] д. <Номер здания>"
    # TODO: Переписать регулярное выражение (скорее всего слишком сложно записано)
    # TODO: Соблюдать ГОСТы и парсить все возможные названия зданий
    regex = \
        r'(?<=г\. )([А-яЁё0-9 \-]+)(?:$|\,|г\.|ул\.|д\.)|' \
        r'(?<=ул\. )([А-яЁё0-9 \/\-]+)(?:$|\,|г\.|ул\.|д\.)|' \
        r'(?<=д\. )([А-яЁё0-9 \/]+)\s*(?:$|\,|г\.|ул\.|д\.)'

    matches = re.findall(regex, addr, flags=re.M | re.I)
    # В регулярном выражении определены 3 группы захвата - для города, улицы и номера дома
    # Достаём всё, что нашли
    cities, streets, houses = [], [], []
    for match in matches:
        if match[0]:
            cities.append(match[0].strip())
        if match[1]:
            streets.append(match[1].strip())
        if match[2]:
            houses.append(match[2].strip())

    return [cities, streets, houses]


# Возвращает JSON-объект, содержащий информацию о ближайшем
# к указанной в строке запросов точке (широта, долгота) полигоне
@app.get('/api/area')
def closest_area():
    # Предполагаем, что аргумент ll содержит (вещественные) широту и долготу, записанные через запятую
    ll = request.args.get('ll', None)
    lat, lon = map(float, ll.split(','))

    json_subq = \
        select(
            polygons.c['gid'],
            func.ST_AsGeoJSON(polygons.c['way']).label('geo')
        ) \
            .subquery()

    stmt = \
        select(
            polygons,
            func.ST_Distance(
                polygons.c['way'],
                func.ST_GeomFromEWKT(f'SRID=4326; POINT({lon} {lat})')
            ).label('dist'),
            json_subq.c['geo']) \
            .join(json_subq, polygons.c['gid'] == json_subq.c['gid']) \
            .where(polygons.c['addr:street'] != None, polygons.c['addr:housenumber'] != None) \
            .order_by('dist') \
            .fetch(1)

    with engine.connect() as conn:
        result = conn.execute(stmt).all()

        dict_result = []
        for row in result:
            dict_result.append(row._asdict())
            del dict_result[-1]['way']
            dict_result[-1]['geo'] = json.loads(dict_result[-1]['geo'])

        return dict_result[0]


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

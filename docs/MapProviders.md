# Map Providers

## Motivations

This work intend to add several functionalities to QGroundControl :

1. Ability to load Custom DEM data (thanks to GDAL library)
2. Ability to connect to a Custom Tile server and add providers at run time
3. Reorganize in a generic manner the way MapProviders are coded : Clean, Ease dev and remove hard coded data at several places which made us unable to add providers at runtime.
4. ElevationProvider inherit completely from MapProviders (So Cache is handled by the same mechanism)

## Related PR

2 branches / PR were associated to this work : 

- [Terrain Provider step 1 : Generic MapProviders #7818 ](https://github.com/mavlink/qgroundcontrol/pull/7818)
    - Introduce Generic class for MapProviders
    - Remove every hardcorded content/urls from several json
    - Add a hash table that store every MapProviders present. This table can be append at run time
    - Re-implement all previously existing providers (Google, Bing, ...)
    - Re-implement elevation provider following the same model
    - Note : Normally no changes from the UI point of view

    [List of Commits](https://github.com/mavlink/qgroundcontrol/pull/7818/commits)


- [Map providers step2 #7898](https://github.com/mavlink/qgroundcontrol/pull/7898)
    - Add GDAL dependency (custom built for Windows,Linux,Android, MacOSX)
    - Implement a new ElevationProvider that read from a folder of geotiff
    - Implement a menu to import a folder of geotiff tiles
    - This was tested with one of our DEM and is known to work.

    [List of Commits](https://github.com/mavlink/qgroundcontrol/pull/7898/commits)

## Intended Architecture

Here a class diagram of the generic MapProvider class :

![image](https://user-images.githubusercontent.com/6662416/70406101-74842f00-1aa4-11ea-9aac-ed0ffd1c1795.png)

### Example

To define a new MapProvider, simply need to redefine a child class of MapProviders :
```
class TestMapProvider : public MapProvider {
    Q_OBJECT
  public:
    TestMapProvider(QObject* parent)
        : MapProvider(QString("https://map.openaerialmap.org"), QString("png"),
                      AVERAGE_TILE_SIZE, QGeoMapType::SatelliteMapDay, parent) {
    }

    QString _getURL(const int x, const int y, const int zoom,
                    QNetworkAccessManager* networkManager) override;
};
```

Where the several constuctor arguments needs to be defineds :

- `QString("https://map.openaerialmap.org")` represents the base of the URL 
- `QString("png")` represents the tile extension
- `AVERAGE_TILE_SIZE` represents the average tile size, used for caching purpose
- `QGeoMapType::SatelliteMapDay` represent the QGeoMapType associated, this is for the QML Map plugin

The method `_getURL` has to be redefined to construct a URL that will fetch a tile, for example :

```
QString TestMapProvider::_getURL(const int x, const int y, const int zoom,
                                        QNetworkAccessManager* networkManager) {
    Q_UNUSED(networkManager);
    return QString("https://tiles.openaerialmap.org/5913eab91acd6100118dd513/0/75ab99f7-5b37-4f59-8392-7276498dc2fc/%1/%2/%3.png")
        .arg(zoom)
        .arg(x)
        .arg(y);
}
```

### Hash Table

Every MapProvider is 

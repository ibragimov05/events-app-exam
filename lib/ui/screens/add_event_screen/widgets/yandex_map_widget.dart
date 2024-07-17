import 'package:events_app_exam/logic/services/location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../widgets/error_dialog.dart';

class YandexMapWidget extends StatefulWidget {
  final void Function(Point) onLocationTap;
  const YandexMapWidget({super.key, required this.onLocationTap});

  @override
  State<YandexMapWidget> createState() => _YandexMapWidgetState();
}

class _YandexMapWidgetState extends State<YandexMapWidget> {
  YandexMapController? _yandexMapController;
  bool _isFetchingAddress = true;
  final List<MapObject> _mapObjects = [];
  Point? _userCurrentPosition;

  void _onMyLocationTapped() {
    if (_userCurrentPosition != null && _yandexMapController != null) {
      _yandexMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _userCurrentPosition!, zoom: 17),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    LocationService.determinePosition().then(
      (value) async {
        if (value != null) {
          _userCurrentPosition = Point(
            latitude: value.latitude,
            longitude: value.longitude,
          );
        }
      },
    ).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => ShowErrorDialog(errorText: error.toString()),
      );
    }).whenComplete(
      () {
        _isFetchingAddress = false;
        setState(() {});
      },
    );
  }

  PlacemarkMapObject? _placemarkMapObject;

  @override
  Widget build(BuildContext context) {
    return _isFetchingAddress
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              YandexMap(
                onMapCreated: (controller) async {
                  _yandexMapController = controller;
                  _yandexMapController!.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _userCurrentPosition!, zoom: 17),
                    ),
                  );
                },
                mapType: MapType.vector,
                onMapTap: (Point point) {},
                zoomGesturesEnabled: true,
                mapObjects: _mapObjects,
                onMapLongTap: (Point argument) {
                  setState(() {
                    _placemarkMapObject = PlacemarkMapObject(
                      mapId: const MapObjectId('event_location'),
                      point: argument,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              "assets/images/place.png"),
                        ),
                      ),
                    );
                    _mapObjects.add(_placemarkMapObject!);
                  });
                  widget.onLocationTap(argument);
                },
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xFF1C1D22),
                    onPressed: _onMyLocationTapped,
                    child: const Icon(
                      Icons.navigation_outlined,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}

import 'dart:async';
import 'package:delivery_flutter/src/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../environment/environment.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';

class DeliveryOrdersMapController extends GetxController{

  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic> {
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(20.1275775,-98.7340033),
      zoom: 14
  );

  LatLng? addressLatLng;
  var addressName=''.obs;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscribe;

  double distanceBetween = 0.0;
  bool isClose = false;

  Completer<GoogleMapController> mapController = Completer();
  Position? position;

  void isCloseToDeliveryPosition() {

    if (position != null) {
      distanceBetween = Geolocator.distanceBetween(
          position!.latitude,
          position!.longitude,
          order.address!.lat!,
          order.address!.lng!
      );

      print('distanceBetween ${distanceBetween}');

      if (distanceBetween <= 200 && isClose == false) {
        isClose = true;
        update();
      }

    }

  }

  DeliveryOrdersMapController(){
    print('Order: ${order.toJson()}');
    checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
    connectAndListen();
  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print('ESTE DISPISITIVO SE CONECTO A SOCKET IO');
    });
  }

  void emitPosition(){
    if(position != null){
      socket.emit('position',{
        'id_order': order.id,
        'lat': position!.latitude,
        'lng': position!.longitude,

      });
    }
  }

  void emitToDelivered() {
    socket.emit('delivered', {
      'id_order': order.id,
    });
  }

  Future setLocationDraggableInfo() async {

    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if (address.isNotEmpty) {
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
      String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      String country = address[0].country ?? '';
      addressName.value = '$direction #$street, $city, $department';
      addressLatLng = LatLng(lat, lng);

      Fluttertoast.showToast(msg: '$addressName');
    }

  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
        configuration, path
    );

    return descriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
    );

    markers[id] = marker;

    update();
  }

  void checkGPS() async {
    deliveryMarker = await createMarkerFromAssets('assets/img/delivery_little2.png');
    homeMarker = await createMarkerFromAssets('assets/img/home.png');

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled == true) {
      updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }

  void updateToDelivered() async {
    if (distanceBetween <= 200) {
      ResponseApi responseApi = await ordersProvider.updateToDelivered(order);
      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        emitToDelivered();
        Get.offNamedUntil('/delivery/home', (route) => false);
      }
    }
    else {
      Get.snackbar('Operacion no permitida', 'Debes estar mas cerca a la posicion de entrega del pedidio');
    }
  }

  void updateLocation() async {
    try{
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)
      saveLocation();
      animateCameraPosition(position?.latitude ?? 1.2004567, position?.longitude ?? -77.2787444);

      addMarker(
          'delivery',
          position?.latitude ?? 1.2004567,
          position?.longitude ?? -77.2787444,
          'Tu posicion',
          '',
          deliveryMarker!
      );

      addMarker(
          'home',
          order.address?.lat ?? 1.2004567,
          order.address?.lng ?? -77.2787444,
          'Lugar de entrega',
          '',
          homeMarker!
      );

      LatLng from = LatLng(position!.latitude, position!.longitude);
      LatLng to = LatLng(order.address?.lat ?? 1.2004567, order.address?.lng ?? -77.2787444);

      LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1
      );

      positionSubscribe = Geolocator.getPositionStream(
          locationSettings: locationSettings
      ).listen((Position pos ) { // POSICION EN TIEMPO REAL
        position = pos;
        addMarker(
            'delivery',
            position?.latitude ?? 1.2004567,
            position?.longitude ?? -77.2787444,
            'Tu posicion',
            '',
            deliveryMarker!
        );
        animateCameraPosition(position?.latitude ?? 1.2004567, position?.longitude ?? -77.2787444);
        emitPosition();
        isCloseToDeliveryPosition();
        //isCloseToDeliveryPosition();
      });

    } catch(e) {
      print('Error: ${e}');
    }
  }

  void callNumber() async{
    String number = order.client?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }

  void saveLocation() async {
    if(position != null){
      order.lat = position!.latitude;
      order.lng = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14,
            bearing: 0
        )
    ));
  }



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    return await Geolocator.getCurrentPosition();
  }

  void onMapCreate(GoogleMapController controller){
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]');
    mapController.complete(controller);
  }

  @override
  void onClose(){
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }

}
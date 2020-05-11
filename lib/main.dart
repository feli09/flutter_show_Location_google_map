import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context);
    pr.style(
      message: 'Buscando...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progress: 0.0,
      progressWidget: Container(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
  }

  Completer<GoogleMapController> _controller = Completer();

  double lat;
  double lon;
  String direccion;

  //Marker list
  final Set<Marker> _markers = {};

  //defalut position
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.195772, -80.629982),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          new Column(
               children: <Widget>[
                 new Container(
                   padding: EdgeInsets.all(50.0),
                   child: new InkWell(
                     child:new Container(
                       decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10.0)
                       ),
                       padding: EdgeInsets.all(10.0),
                       child:  new Row(
                         children: <Widget>[

                           new SizedBox(width: 10.0),
                           new Expanded(child: new Text("Delivery GO", textAlign: TextAlign.center,)),
                           new SizedBox(width: 10.0),

                         ],
                       ),
                     ),
                   ),
                 ),
                 new Expanded(child: new Container()),
                 new Container(
                   alignment: Alignment.topRight,
                   padding: EdgeInsets.all(20.0),

                   child: new GestureDetector(
                     onTap: (){
                       goToMyLocation();
                     },
                     child: new Container(
                       padding: EdgeInsets.all(10.0),
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: Colors.transparent
                       ),
                       child: Icon(Icons.my_location, color: Colors.purple,size: 30.0,),
                     ),
                   ),
                 ),
                 new Container(
                   padding: EdgeInsets.all(20.0),
                   margin: EdgeInsets.all(10.0),
                   decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(10.0)
                   ),
                   child: new Column(
                     children: <Widget>[
                       new Container(
                         width: double.infinity,
                         padding: EdgeInsets.all(10.0),
                         decoration: BoxDecoration(
                             border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3))
                         ),
                         child: InkWell(
                           /*onTap: ()async{
                             Place place  = await Navigator.push(context, new MaterialPageRoute(builder: (context)=> new OpenStreetMapPlacesAutoCompleteWidget(_currentCountry)));
                             if(place != null && mounted){
                               setState(() {
                                 _currentPlace = place;

                                 _latLng= new LatLng(double.parse(place.lat), double.parse(place.lon));
                                 print('Upadate maker $_latLng');
                                 _mapController.move(_latLng, 17.0);

                               });
                             }
                           },*/
                           child: new Row(
                             children: <Widget>[
                               Icon(Icons.location_on),
                               new SizedBox(width: 10.0,),
                               Expanded(child: new Text(direccion == null?  "Busque su direccion" : direccion, style: TextStyle(fontSize: 18.0, ),))
                             ],
                           ),
                         ),
                       ),
                       new SizedBox(height: 15.0,),
                       new Container(
                         width: double.infinity,
                         child: new RaisedButton(onPressed: (){

                           //Navigator.pop(context, _currentPlace);

                         },
                             color: Colors.purple,
                             textColor: Colors.white,
                             child: Padding(
                               padding: const EdgeInsets.all(13.0),
                               child: new Text("Guardar",style: new TextStyle(fontSize: 18.0), ),
                             ),
                             shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),side: BorderSide(color: Colors.purple))


                         ),
                       )
                     ],
                   ),
                 )
               ],
          )
       ],
      )

    );
  }

  Future<void> goToMyLocation() async {
    _getLocation();
  }

  var location = new Location();

  void showProgressDialog()async{
    await pr.show();
  }

  void hideProgressDialog()async{
    await pr.hide();
  }

  _getLocation() async {
    showProgressDialog();
    var error;
    //var currentLocation = LocationData;
    var currentLocation;
    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }

    lat = currentLocation.latitude;
    lon = currentLocation.longitude;

    //pintar latitude , longitude
    print("coordenadas" + '${lat},${lon}');

    final CameraPosition _here = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 16,
    );

    //Muévete a tu ubicación
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_here));

    //Obtener dirección por latitud y longitud
    final coordinates = new Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    hideProgressDialog();
    var first = addresses.first;
    //direccion = first.featureName;
    //print all address data
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    //print("direccion"  + direccion);
    //Datos de destinatarios principales
    var add = '${first.subAdminArea},${first.addressLine}';
    direccion = '${first.addressLine}';
    //Agregar marcador al mapa
    _onAddMarkerButtonPressed(lat, lon, add);
  }

  void _onAddMarkerButtonPressed(lat, lon, add) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("Estoy aquí"),
        position: LatLng(
          lat,
          lon,
        ),
        infoWindow: InfoWindow(
          title: '${lat},${lon}',
          snippet: add,
          onTap: (){
            print("info a guardar" +  '${lat},${lon}'  +  add);
          }
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
}



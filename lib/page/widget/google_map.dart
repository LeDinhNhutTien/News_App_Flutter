import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/widget/google_map_screens/current_location_screen.dart';
import 'package:flutter_news_app/page/widget/google_map_screens/nearby_places_screen.dart';
import 'package:flutter_news_app/page/widget/google_map_screens/search_places_screen.dart';
import 'package:flutter_news_app/page/widget/google_map_screens/simple_map_screen.dart';

import 'google_map_screens/polyline_screen.dart';

class GoogleMap extends StatefulWidget {
  const GoogleMap({Key? key}) : super(key: key);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const SimpleMapScreen();
              }));
            }, child: const Text("Simple Map")),

            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const CurrentLocationScreen();
              }));
            }, child: const Text("Vị trí hiện tại")),

            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const SearchPlacesScreen();
              }));
            }, child: const Text("Tìm kiếm địa điểm")),


            // ElevatedButton(onPressed: (){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            //     return const NearByPlacesScreen();
            //   }));
            // }, child: const Text("Near by Places")),


            // ElevatedButton(onPressed: (){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            //     return const PolylineScreen();
            //   }));
            // }, child: const Text("Polyline between 2 points"))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Controlllers/locationProvider.dart';
import 'package:vpn_app/Models/vpn.dart';
import 'package:vpn_app/Views/constant.dart';
import 'package:vpn_app/Views/customWidget/CountryCard.dart';
import 'package:vpn_app/Views/customWidget/VpnCard.dart';
import 'package:vpn_app/Views/customWidget/alertbox.dart';

class LocationScreen extends StatefulWidget {
  final List<Vpn> serverList;
  final List<String> countries;
  final List<String> flags;

  LocationScreen({Key? key, required this.serverList, required this.flags, required this.countries}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final String apiURL = "http://www.vpngate.net/api/iphone";
  List<String> countries = [];
  String? selectedCountry;
  List<Vpn> servers = [];
  List<String> flags = [];
  bool istap = false;
  String? expandedCountry;

  @override
  void initState() {
    super.initState();
    gettingServers();
  }

  void gettingServers() async {
    final locationController = Provider.of<LocationProvider>(context, listen: false);

    try {
      // Check if data has already been loaded
      if (widget.countries.isEmpty) {
        // Load VPN and countries data
        if (locationController.vpnList.isEmpty) {
          await locationController.getVpnData();
        }
        if (locationController.countrylist.isEmpty || locationController.flaglist.isEmpty) {
          await locationController.getCountriesData();
        }

        // Update state if component is still mounted
        if (mounted) {
          setState(() {
            servers = locationController.vpnList;
            countries = locationController.countrylist;
            flags = locationController.flaglist;
          });
        }
      } else {
        // Use data already provided
        if (mounted) {
          setState(() {
            servers = widget.serverList;
            countries = widget.countries;
            flags = widget.flags;
          });
        }
      }
    } catch (e) {
      print('Error in getting servers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFF121A2E),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121A2E),
        title: Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 26),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                flex: 12,
                  child: locationController.isLoading
                     ? _loadingWidget(context)
                     : locationController.vpnList.isEmpty
                     ? _noVPNFound(context)
                     : serversData(),

              )
            ],
          ),
        ),
      ),
    );
  }

  ///Loading Indicator
  _loadingWidget(context) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///lottie animation
        LottieBuilder.asset(
          'assets/animation/new_loading.json',
          width: 220,
        ),

        /// loading text
        Padding(padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
          child: Text(

            '         Loading Servers....\nPlease have some Patience. Good Things takes Time😊 ',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fade().slideY(begin: 0.2, end: 0, curve: Curves.easeIn),
        ),
      ],
    ),
  );

  ///InCase there is no Data
  _noVPNFound(context) => Container(
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2C45),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.signal_wifi_off,
          size: 70,
          color: const Color(0xFF00BCD4),
        ),
        SizedBox(height: 20),
        Text(
          'Sorry, VPNs Not Found! 😔',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  serversData() {
    final locationController = Provider.of<LocationProvider>(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shrinkWrap: true,
      itemCount: countries.length,
      itemBuilder: (context, index) {
        if (index >= countries.length || index >= flags.length) {
          return SizedBox.shrink(); // Prevent index out of range errors
        }

        final country = countries[index];
        final flag = flags[index];

        return Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C45),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: locationCard(
            isExpanded: country == expandedCountry,
            countryName: country,
            flag: flag,
            tap: (istap) async {
              setState(() {
                if (expandedCountry == country) {
                  expandedCountry = null;
                  istap = false;
                  servers = locationController.vpnList;
                } else {
                  expandedCountry = country;
                  istap = true;
                  List<Vpn> specificCountryServers = serversForSelectedCountry(country, context);
                  servers = specificCountryServers;
                }
              });
            },
            servers: locationController.vpnList.isEmpty
                ? [CircularProgressIndicator()]
                : servers.where((server) =>
            server.countryLong.toLowerCase() == country.toLowerCase()
            ).map((server) => VpnCard(vpn: server)).toList(),
          ),
        ).animate().fade(duration: 300.ms);
      },
    );
  }

  List<Vpn> serversForSelectedCountry(String country, context) {
    final locationController = Provider.of<LocationProvider>(context, listen: false);
    List<Vpn> data = locationController.vpnList;
    List<Vpn> myservers = data.where((server) => server.countryLong.toLowerCase() == country.toLowerCase()).toList();
    return myservers;
  }
}

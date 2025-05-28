import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vpn_app/Handlers/location_provider.dart';
import 'package:vpn_app/data/Models/vpn_main.dart';

import 'package:vpn_app/Views/core/components/Country_card.dart';
import 'package:vpn_app/Views/core/components/Vpn_card.dart';
import 'package:vpn_app/Views/core/components/alertBox.dart';

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
        title: const Text(
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
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
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
        Padding(padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
          child: const Text(

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
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2C45),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.signal_wifi_off,
          size: 70,
          color: Color(0xFF00BCD4),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shrinkWrap: true,
      itemCount: countries.length,
      itemBuilder: (context, index) {
        if (index >= countries.length || index >= flags.length) {
          return const SizedBox.shrink(); // Prevent index out of range errors
        }

        final country = countries[index];
        final flag = flags[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2C45),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                ? [const CircularProgressIndicator()]
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

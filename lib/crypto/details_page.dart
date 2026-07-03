import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  String name;
  String imageurl;
  String price;
  String id;

  DetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.imageurl,
    required this.price,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<CandlestickSpot> historicalData = [];

  Future<void> getCryptoApi(int duration) async {
    // Bepul endpoint — prices + market_caps + total_volumes qaytaradi
    final String api =
        "https://api.coingecko.com/api/v3/coins/${widget.id}/market_chart"
        "?vs_currency=usd&days=$duration&interval=daily&precision=0";

    try {
      final response = await http.get(Uri.parse(api));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> prices =
            body['prices']; // [[timestamp, price], ...]

        setState(() {
          historicalData = List.generate(prices.length, (i) {
            final double price = prices[i][1].toDouble();

            // Oldingi narxdan open yasaymiz
            final double open = i > 0 ? prices[i - 1][1].toDouble() : price;
            final double close = price;
            final double high =
                [open, close].reduce((a, b) => a > b ? a : b) * 1.003;
            final double low =
                [open, close].reduce((a, b) => a < b ? a : b) * 0.997;

            return CandlestickSpot(
              x: i.toDouble(),
              open: open,
              high: high,
              low: low,
              close: close,
            );
          });
        });
      } else {
        print("Error: ${response.statusCode} — ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCryptoApi(30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.imageurl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Current Price : ${widget.price} \$",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.36,
            child: CandlestickChart(
              CandlestickChartData(
                backgroundColor: Colors.black,
                candlestickSpots: historicalData, // List<CandlestickSpot>
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 50,
                      showTitles: true,
                      interval: 10_000,
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(reservedSize: 44, showTitles: true),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(reservedSize: 44, showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(reservedSize: 44, showTitles: false),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
          ),
        ],
      ),
    );
  }
}

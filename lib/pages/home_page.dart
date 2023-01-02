import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/cubits/weather_cubit/weather_cubit.dart';

import 'package:weather_app/cubits/weather_cubit/weather_state.dart';

import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/providers/weather_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text('Weather App'),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherSuccess) {
            return successBody(state.weatherModel, context);
          } else if (state is WeatherFailure) {
            return const Center(
              child: Text('something wrong'),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'there is no weather 😔 start',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'searching now 🔍',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Container successBody(WeatherModel? weatherData, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          weatherData!.getThemeColor(),
          weatherData.getThemeColor()[300]!,
          weatherData.getThemeColor()[100]!,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          Text(
            BlocProvider.of<WeatherCubit>(context).cityName.toString(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'updated at : ${weatherData.date.hour} : ${weatherData.date.minute}',
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(BlocProvider.of<WeatherCubit>(context, listen: false)
                  .weatherModel!
                  .getImage()),
              Text(
                BlocProvider.of<WeatherCubit>(context, listen: false)
                    .weatherModel!
                    .temp
                    .toInt()
                    .toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Text(BlocProvider.of<WeatherCubit>(context, listen: false)
                      .weatherModel!
                      .maxTemp
                      .toInt()
                      .toString()),
                  Text(BlocProvider.of<WeatherCubit>(context, listen: false)
                      .weatherModel!
                      .minTemp
                      .toInt()
                      .toString()),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            BlocProvider.of<WeatherCubit>(context, listen: false)
                .weatherModel!
                .weatherStateName
                .toString(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(
            flex: 6,
          ),
        ],
      ),
    );
  }
}

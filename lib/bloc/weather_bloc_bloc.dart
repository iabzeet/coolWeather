import 'package:bloc/bloc.dart';
import 'package:coolweather/models/my_data.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      //when we start it's loading
      emit(WeatherBlocLoading());
      try {
        WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
        
        //when we reach here, permisssions are granted and we can
        // continue accessing the posiiton of the device
        //Position position = await Geolocator.getCurrentPosition();   //giving us a positon as a future
        
        Weather weather = await wf.currentWeatherByLocation(
          event.position.latitude, 
          event.position.longitude
        );
        emit(WeatherBlocSuccess(weather));
        print(weather);
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }
}

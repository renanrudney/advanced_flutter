import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

final class MapperSpy<Dto> implements Mapper<Dto> {
  Json? toDtoInput;
  int toDtoInputCallsCount = 0;
  Dto toDtoOutput;

  MapperSpy({
    required this.toDtoOutput
  });

  @override
  Dto toDto(Json json) {
    toDtoInput = json;
    toDtoInputCallsCount++;
    return toDtoOutput;
  }

  @override
  Json toJson(Dto dto) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

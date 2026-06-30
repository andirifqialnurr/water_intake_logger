import 'package:equatable/equatable.dart';

class HydrationEntryLog extends Equatable {
  final int id;
  final int amountMl;
  final String sourceType;
  final String sourceLabel;
  final DateTime consumeAt;
  final String localDate;

  const HydrationEntryLog({
    required this.id,
    required this.amountMl,
    required this.sourceType,
    required this.sourceLabel,
    required this.consumeAt,
    required this.localDate,
  });

  bool get isCorrection => amountMl < 0;
  int get displayAmountMl => amountMl.abs();

  @override
  List<Object?> get props => [
    id,
    amountMl,
    sourceType,
    sourceLabel,
    consumeAt,
    localDate,
  ];
}

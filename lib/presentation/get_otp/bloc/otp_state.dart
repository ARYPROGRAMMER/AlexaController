import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OtpInitialState extends OtpState {}

class OtpLoadingState extends OtpState {}

class OtpVerifiedState extends OtpState {}

class OtpVerificationFailedState extends OtpState {
  final String error;

  OtpVerificationFailedState(this.error);

  @override
  List<Object?> get props => [error];
}

class OtpResendingState extends OtpState {}

class OtpResentState extends OtpState {}

class OtpResendFailedState extends OtpState {
  final String error;

  OtpResendFailedState(this.error);

  @override
  List<Object?> get props => [error];
}

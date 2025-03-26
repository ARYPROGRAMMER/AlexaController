import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyOtpEvent extends OtpEvent {
  final String phoneNumber;
  final String otp;

  VerifyOtpEvent(this.phoneNumber, this.otp);

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class ResendOtpEvent extends OtpEvent {
  final String phoneNumber;

  ResendOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

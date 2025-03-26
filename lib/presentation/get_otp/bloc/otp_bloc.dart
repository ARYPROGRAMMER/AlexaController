import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/auth_repository/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository authRepository;

  OtpBloc(this.authRepository) : super(OtpInitialState()) {
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    try {
      await authRepository.verifyOtp(event.phoneNumber, event.otp);
      emit(OtpVerifiedState());
    } catch (error) {
      emit(OtpVerificationFailedState(error.toString()));
    }
  }

  Future<void> _onResendOtp(
      ResendOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpResendingState());
    try {
      await authRepository.initiateLogin(event.phoneNumber);
      emit(OtpResentState());
    } catch (error) {
      emit(OtpResendFailedState(error.toString()));
    }
  }
}




import '../../../auth/form_submission_status.dart';

class LedgerState{
  final List<dynamic> nData;
  final FormSubmissionStatus formStatus;
  
  LedgerState({
    this.formStatus = const InitialFormStatus(),
    this.nData = const [],
  });

  LedgerState copyWith({
     FormSubmissionStatus? formStatus,
    List<dynamic>? nData
    }) {
      return LedgerState(
        nData: nData ?? this.nData,
        formStatus: formStatus ?? this.formStatus,
      );
    }
}

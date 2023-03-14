
abstract class SettingEvent {}
class ProfileInitial extends SettingEvent{}
class UpdatePassword extends SettingEvent{}

class OldPasswordChange extends SettingEvent{
  final String nOldPassword;
  OldPasswordChange({required this.nOldPassword});
}

class NewPasswordChange extends SettingEvent{
  final String nNewPassword;
  NewPasswordChange({required this.nNewPassword});
}
class ReTypePasswordChange extends SettingEvent{
  final String nReTypePassword;
  ReTypePasswordChange({required this.nReTypePassword});
}
class ShopNameChange extends SettingEvent{
  final String nShopName;
  ShopNameChange({required this.nShopName});
}
class ContactNoChange extends SettingEvent{
  final String nContact;
  ContactNoChange({required this.nContact});
}
class ProfileUpdate extends SettingEvent{}

class SettingSubmitted extends SettingEvent{}
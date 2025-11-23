class ChangePasswordDTO {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  ChangePasswordDTO(
      this.currentPassword, this.newPassword, this.confirmPassword);
}

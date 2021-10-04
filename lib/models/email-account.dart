class EmailAccount {
  String emailAddress;
  String password;
  String? server;

  EmailAccount(this.emailAddress, this.password, this.server);
}

/// Find an email account in the list using emailAddress for search
EmailAccount findEmailAccountByAddress(
    List<EmailAccount> emails, String emailAddress) {
  final EmailAccount emailAccount = emails.firstWhere(
      (element) => element.emailAddress == emailAddress, orElse: () {
    return EmailAccount('none', 'none', 'none');
  });
  return emailAccount;
}

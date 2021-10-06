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

List<EmailAccount> emailAccountList = [
  EmailAccount('info@sqlprompt.net', 'nopasswordhere', 'smtp.ethereal.email'),
  EmailAccount('kade.koss49@ethereal.email', 'W7NyENBmpe1tYw3ZCu',
      'smtp.ethereal.email'),
  EmailAccount('test1', 'pass', 'servername')
];

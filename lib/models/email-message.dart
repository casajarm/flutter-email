class EmailMessage /*extends Model*/ {
  String fromUser = 'test@email.com'; //TODO: Map this to a user class?
  String subject = 'hiking';
  String message = 'traveling';
  save() {
    print('saving message');
  }
}
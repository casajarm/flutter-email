class EmailMessage /*extends Model*/ {
  String? fromUser; //TODO: Map this to a user class?
  String? subject = 'hiking';
  String? message = 'traveling';
  save() {
    print(
        'saving message from: $fromUser | subject: $subject | message: $message');
  }
}

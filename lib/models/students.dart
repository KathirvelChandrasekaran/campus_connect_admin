class Students {
  String? rollnumber;
  String? emailid;

  Students(
    this.rollnumber,
    this.emailid,
  );

  Map toJson() => {
        'roll_number': rollnumber,
        'email_id': emailid,
      };

  Students.fromList(List<dynamic> list) {
    rollnumber = list[0];
    emailid = list[1];
  }
  @override
  String toString() {
    return '{$rollnumber,$emailid}';
  }
}

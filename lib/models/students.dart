class Students {
  String? rollnumber;
  String? emailid;
  String? department;

  Students(this.rollnumber, this.emailid, this.department);

  Map toJson() => {
        'roll_number': rollnumber,
        'email_id': emailid,
        'department': department,
      };

  Students.fromList(List<dynamic> list) {
    rollnumber = list[0];
    emailid = list[1];
    department = list[2];
  }
  @override
  String toString() {
    return '{$rollnumber,$emailid,$department}';
  }
}

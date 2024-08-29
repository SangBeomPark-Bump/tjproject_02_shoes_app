class Branch{

  int? branchcode;
  String branchname;

  Branch({
    required this.branchname
  });

  Branch.fromMap(Map<String, dynamic> res)
: branchcode = res['branchcode'],
  branchname = res['branchname'];
}
class Branch{

  int? branchcode; // Auto increment
  String branchname; // '강남점', '신도림점', '노원점' 세개

  Branch({
    required this.branchname
  });

  Branch.fromMap(Map<String, dynamic> res)
: branchcode = res['branchcode'], 
  branchname = res['branchname'];
}
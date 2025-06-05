enum StepType {
  init(''),
  dataLoad('Data Load'),
  authCheck("Auth Check");

  const StepType(this.name);
  final String name;
}

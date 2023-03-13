enum MainOption {
  projects(value:"projects"), stats(value:'stats'), settings(value: 'settings');


  const MainOption({required this.value});

  final String value;
}
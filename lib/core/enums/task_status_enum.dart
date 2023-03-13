enum TaskStatus{
  Pending(status:"PENDING"), Completed(status:"COMPLETED"), Abandoned(status:"ABANDONED") ;
  const TaskStatus({required this.status});
  final String status;
}
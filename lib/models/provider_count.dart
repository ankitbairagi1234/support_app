class ProviderCount {
  int? status;
  String? message;
  Data? data;

  ProviderCount({this.status, this.message, this.data});

  ProviderCount.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? task;
  int? pendingTask;
  int? activeTask;
  int? rejectTask;
  int? doneTask;

  Data(
      {this.task,
        this.pendingTask,
        this.activeTask,
        this.rejectTask,
        this.doneTask});

  Data.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    pendingTask = json['pending_task'];
    activeTask = json['active_task'];
    rejectTask = json['reject_task'];
    doneTask = json['done_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    data['pending_task'] = this.pendingTask;
    data['active_task'] = this.activeTask;
    data['reject_task'] = this.rejectTask;
    data['done_task'] = this.doneTask;
    return data;
  }
}
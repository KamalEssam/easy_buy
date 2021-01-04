import 'dart:async';

class ActionReport {
  String actionName;
  ActionStatus status;
  String msg;

  ActionReport({
    this.actionName,
    this.status,
    this.msg,
  });

  ActionReport copyWith({
    String actionName,
    ActionStatus status,
    String msg,
  }) {
    return ActionReport(
      actionName: actionName ?? this.actionName,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }
}

enum ActionStatus { running, complete, complete_no_more, error }

class Action {
  final String actionName;
  final Completer<ActionReport> completer;

  Action(this.completer, this.actionName);
}

void catchError(action, error) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.error,
        msg: "${action.actionName} is error;${error.toString()}"));
  }
}

void completed(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.complete,
        msg: "${action.actionName} is completed"));
  }
}

void noMoreItem(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.complete,
        msg: "no more items"));
  }
}

void idEmpty(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.error,
        msg: "Id is empty"));
  }
}

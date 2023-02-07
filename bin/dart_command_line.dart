import 'dart:io';

void main(List<String> arguments) {
  Process.run('tmux', []);
  Future.delayed(Duration(seconds: 1), (){
    Process.run('appium', []);
  });
  Process.run('tmux', ['detach']);
}

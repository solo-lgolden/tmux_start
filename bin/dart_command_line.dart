import 'dart:io';

Map<String, String> environmentVariables = {};

void main(List<String> arguments) async {
  environmentVariables = Platform.environment;
  await installDependencies();
  await createAndInstallEmulator();
  await launchAppium();
  await runTests();
}

Future<void> launchAppium() async {
  print('Executing tmux and appium');
  await Process.run('tmux', []);
  Future.delayed(Duration(seconds: 1), (){
    Process.run('appium', []);
  });
  await Process.run('tmux', ['detach']);
}

Future<void> installDependencies()async{
  print('Installing dependencies');
  await Process.run("pip", ["install", "-r", "bin/requirements.txt"]);
  await Process.run("brew", ["install", "tmux"]);
}

Future<void> createAndInstallEmulator()async{
  print('Installing Emulator');
  await Process.run("android", ["create avd", "-n my_avd", '-t 29']);
  await Process.run("emulator", ["-avd my_avd"]);
  await Process.run("adb", ["install ${environmentVariables['AWS_APK_PATH']}"]);
}

Future<void> runTests()async{
  print('Running tests');
  await Process.run('robot', ["solo_appbeta_e2e.robot"]);
}

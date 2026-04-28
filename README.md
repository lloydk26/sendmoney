# send_money

## Run the Application

Follow these steps in order from the project root:

1. Install FVM:
   ```bash
   dart pub global activate fvm
   ```

2. Add FVM to your terminal PATH:
   ```bash
   export PATH="$PATH:$HOME/.pub-cache/bin"
   ```

3. Install the exact Flutter version required by this project:
   ```bash
   fvm install 3.41.8
   ```

4. Install dependencies:
   ```bash
   fvm flutter pub get
   ```

5. Run code generation for Retrofit and other generated files:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. Run the project:
   ```bash
   fvm flutter run
   ```

## Run Unit Tests

Before running unit tests, make sure generated files are up to date:

1. Run code generation:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. Run unit tests:
   ```bash
   fvm flutter test
   ```

## Notes

- iOS is not set up yet because it requires creating an Apple Developer account.

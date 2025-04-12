# runs the flutter app for your local system.
run:
    flutter run

# cleans any leftover build files from your machine.
clean:
    flutter clean

# builds for the web.
build-web:
    flutter build web --release

# builds for android.
build-android:
    flutter build apk --release

# runs ci through the `act` local action runner.
#
# for more information, please see: https://just.systems
ci:
    @ echo "note: you might need to type your password!"
    sudo act
    @ echo "local ci run completed!"

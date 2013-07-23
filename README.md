Simple wrapper around LeapMotion APIs.  This will allow JRuby to use LeapMotion with some Rubyisms added to make it feel more natural.

Until I figure if I can ship the binaries needed to make this self-contained I will just mention you need to have a version of LeapMotions SDK installed on your machine and then you need to point JRuby at it like:

```text
CLASSPATH=../leap_sdk/LeapSDK/lib/LeapJava.jar jruby -J-Djava.library.path=../leap_sdk/LeapSDK/lib -Ilib examples/sample.rb
```

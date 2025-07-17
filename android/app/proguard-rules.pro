-keep class com.hiennv.flutter_callkit_incoming.** { *; }
# Agora keep rules
-keep class io.agora.** { *; }
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }

# Stripe Push Provisioning keep rules
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivity { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider { *; }

-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

# Prevent stripping of Kotlin classes and AndroidX
-keep class kotlin.** { *; }
-keep class androidx.** { *; }

-keepclassmembers class ai.deepar.ar.DeepAR { *; }
-keepclassmembers class ai.deepar.ar.core.videotexture.VideoTextureAndroidJava { *; }
-keep class ai.deepar.ar.core.videotexture.VideoTextureAndroidJava

-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# ProGuard rules for uCrop
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**


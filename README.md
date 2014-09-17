![](http://f.cl.ly/items/0W2i0E151s0B3S3x3E3W/ogp_.jpg)

iOS8-Sampler
============

Code examples for the new functions of iOS 8.

<img src="http://f.cl.ly/items/2m0W310X0f0J2Z0b0o2r/top.jpg" width="240">


##How to build

JUST BUILD basically, however please note below:


###Schemes

- Use "iOS8Sampler" Scheme for DEVICES.
- Use "iOS8SamplerSimulator" Scheme for SIMULATORS

(This is because Metal can't be compiled for Simulators.)


###Provisioning Profile

When try the HealthKit or HomeKit examples, you have to use a provisioning profile for which HealthKit or HomeKit are enabled.


##Contents


###Audio Effects

Distortion and Delay effect for audio using AVAudioEngine.

<img src="ResourcesForREADME/effects.jpg" width="200">

                   
###New Image Filters

New filters of CIFilter such as CIGrassDistortion, CIDivideBlendMode, etc...

<img src="ResourcesForREADME/coreimage.jpg" width="200">


###Custom Filters

Custom CIFilter examples using CIKernel.

<img src="ResourcesForREADME/customfilter.jpg" width="200">


###Metal Basic

Render a set of cubes using Metal. Based on Apple's "MetalBasic3D" sample.

<img src="ResourcesForREADME/metal1.jpg" width="200">


###Metal Uniform Streaming

Demo using a data buffer to set uniforms for the vertex and fragment shaders.

<img src="ResourcesForREADME/metal2.jpg" width="200">


###SceneKit

Render a 2D image on 3D scene using SceneKit framework.

<img src="ResourcesForREADME/scene.jpg" width="200">


###HealthKit

Fetch all types of data which are available in HealthKit. Need to use a provisioning profile for which HealthKit is enabled.

<img src="ResourcesForREADME/health.jpg" width="200">

                   
###TouchID

Invoke Touch ID verification using LocalAuthentication.

<img src="ResourcesForREADME/touch.jpg" width="200">


###Visual Effects

Example for UIBlurEffect and UIVibrancyEffect.

<img src="ResourcesForREADME/visualeffect.jpg" width="200">


###WebKit

Browsing example using WKWebView.

<img src="ResourcesForREADME/webkit.jpg" width="200">


###UIAlertController

Show Alert or ActionSheet using UIAlertController.

<img src="ResourcesForREADME/alert.jpg" height="355">


###User Notification

Schedule a local notification which has custom actions using UIUserNotificationSettings.

<img src="ResourcesForREADME/notification.jpg" height="355">


###Pedometer

Counting steps demo using CMPedometer. It works only on devices which have M7 or M8 motion co-processor.

<img src="ResourcesForREADME/pedometer.jpg" width="200">


###AVKit

Media playback demo using AVKit framework.

<img src="ResourcesForREADME/avkit.jpg" width="200">

                   
###Histogram

Generate a histogram from an image using the filters CIAreaHistogram and CIHistogramDisplayFilter.

<img src="ResourcesForREADME/histo.jpg" width="200">


###Code Generator

Generate Aztec Code and 128 Barcord.

<img src="ResourcesForREADME/codegen.jpg" height="355">


###New Fonts

Gallery of new fonts.

<img src="ResourcesForREADME/font.jpg" width="200">


###Popover

Example of UIPopoverPresentationController.

<img src="ResourcesForREADME/popover.jpg" width="200">


###Accordion Fold Transition

Transitions from one image to another by folding like accordion. However it doesn't work correctly...**PULL REQUESTS welcome**!!


##Author

Shuichi Tsutsumi

- [Twitter](https://twitter.com/shu223)
- [Facebook](https://www.facebook.com/shuichi.tsutsumi)
- [LinkedIn](https://www.linkedin.com/profile/view?id=214896557)
- [Blog (Japanese)](http://d.hatena.ne.jp/shu223/)


##Special Thanks

Icons and LaunchImages are **designed by [Okazu](https://www.facebook.com/pashimo)**


##Donation for iOS8-Sampler

If you like this project, or want to support the development, feel free to Donate.

<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="BHM7YTWHK7ARS">
<table>
<tr><td><input type="hidden" name="on0" value="DonationType">DonationType</td></tr><tr><td><select name="os0">
	<option value="Donation1">Donation1 $1.00 USD</option>
	<option value="Donation2">Donation2 $2.00 USD</option>
	<option value="Donation3">Donation3 $5.00 USD</option>
</select> </td></tr>
</table>
<input type="hidden" name="currency_code" value="USD">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - オンラインでより安全・簡単にお支払い">
<img alt="" border="0" src="https://www.paypalobjects.com/ja_JP/i/scr/pixel.gif" width="1" height="1">
</form>

Thanks to all contributors!

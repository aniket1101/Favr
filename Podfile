# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FavrApplication' do
  use_frameworks!

# Firebase
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Analytics'
pod 'Firebase/Crashlytics'
pod 'Firebase/Performance'
pod 'FirebaseUI/Storage'

# Facebook
pod 'FBSDKLoginKit', '7.1.1'

# Google Sign IN
pod 'GoogleSignIn'

# pod 'MessageKit'
# pod 'InputBarAccessoryView', '5.1.0'
pod 'JGProgressHUD'
pod 'RealmSwift'
pod 'SDWebImage'
pod 'SwiftDate'
pod 'lottie-ios'
pod 'liquid-swipe'
pod 'UIView+Shake'
pod 'Hue'
pod 'MaterialComponents/ActionSheet'
pod 'SwiftEntryKit'
pod "Pastel"
pod 'Hero'
pod 'ShimmerSwift'
pod 'TransitionButton'

end  

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
           end
       end
   end
end

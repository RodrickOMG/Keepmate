# Uncomment the next line to define a global platform for your project
# platform :ios, '13.2'

target 'Keepmate' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Keepmate
  pod 'BmobSDK'

end

inhibit_all_warnings!

#取消其他第三方库的警告信息     post_install do |installer|       installer.pods_project.targets.each do |target|         target.build_configurations.each do |config|           config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'         end       end     end

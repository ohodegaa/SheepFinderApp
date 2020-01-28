platform :ios, '13.2'
use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == "DJIWidget"
            puts "Processing for disable bit code in YOUR SDK TARGET NAME SDK"
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end


target 'SheepFinder' do
   pod 'DJI-SDK-iOS', '~> 4.11.1'
   pod 'DJIWidget', '~> 1.6.2'
   pod 'DJIFlySafeDatabaseResource', '~> 01.00.01.17'
end

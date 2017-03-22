Pod::Spec.new do |s|
  s.name        = 'AutoToggleHeaderFooterView'
  s.version     = '1.0.0'
  s.summary     = 'A header and footer toggle display-state depending on the scroll or time interval'
  s.homepage    = 'https://github.com/recruit-lifestyle/AutoToggleHeaderFooterView'
  s.license     = 'Apache License, Version 2.0'
  s.author      = { 'Tomoya Hayakawa' => 'rhd_internship_ER5@r.recruit.co.jp' }
  s.source      = { :git => 'https://github.com/recruit-lifestyle/AutoToggleHeaderFooterView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.platform = :ios, '8.0'

  s.source_files = 'AutoToggleHeaderFooterView/Classes/**/*'
end

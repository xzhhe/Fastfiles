## 支持的功能

### romove derived data

```ruby
rm_derived_data
rm_derived_data(system_derived_data: true)

rm_derived_data(
  xcodeproj: '/Users/xiongzenghui/Desktop/DemoHaha/DemoHaha.xcodeproj',
  scheme: 'DemoHaha'
)

rm_derived_data(
  xcodeproj: '/Users/xiongzenghui/Desktop/DemoHaha/DemoHaha.xcodeproj',
  scheme: 'DemoHaha',
)

rm_derived_data(
  workspace: '/Users/xiongzenghui/ios_projects/osee2unified/osee2unified/osee2unified.xcworkspace',
  scheme: 'osee2unifiedRelease'
)

rm_derived_data(
  workspace: '/Users/xiongzenghui/ios_projects/osee2unified/osee2unified/osee2unified.xcworkspace',
  scheme: 'osee2unifiedRelease',
  module_cache_noindex: true
)
```

### deploy pod

```ruby
deploy_ios_pod(
  podspec: '/path/to/xx.podspec',
  branch: 'master',
  version: '1.1.0'
)
```

### generate iOS ipa qr code url

```ruby
qrcode(plist: 'http://..../xx.plist', qrcode_api: 'https://xx.com/image_share/qrcode?content=')
```

### get dsym uuid

```ruby
pp dsym_uuid(dsym: '/Users/xiongzenghui/Desktop/release-502.dSYM/osee2unifiedRelease.app.dSYM')
pp dsym_uuid(dsyms: [
  '/Users/xiongzenghui/Desktop/release-502.dSYM/osee2unifiedRelease.app.dSYM',
  '/Users/xiongzenghui/Desktop/release-502.dSYM/Share.appex.dSYM',
  '/Users/xiongzenghui/Desktop/release-502.dSYM/notificationService.appex.dSYM',
  '/Users/xiongzenghui/Desktop/release-502.dSYM/todayWidget.appex.dSYM'
])
```


# rn-pocket-pingpp

安装：

    npm install https://github.com/luojuan822/rn-pocket-pingpp.git

ios 使用说明:

1.将ios文件夹下的PingppSDK拖拽到项目文件夹(例如pocket)下,选择create groups,不copy

2.将项目文件PingPayManager.h、PingPayManager.m文件拖拽到项目文件夹(例如pocket)下,选择create groups,不copy

3.依赖 Frameworks

    CFNetwork.framework
    SystemConfiguration.framework
    Security.framework
    QuartzCore.framework
    CoreTelephony.framework
    CoreMotion.framework
    libc++.tbd
    libz.tbd
    libsqlite3.0.tbd
    libstdc++.tbd

4.配置Build Settings下的Framework Search Paths(用于寻找AliPay.framework)和Library Search Paths(用于寻找.a的library)

Framework Search Paths 设置

    $(inherited)
    $(PROJECT_DIR)/../node_modules/rn-pocket-pingpp/ios/PingppSDK/Channels/Alipay

Library Search Paths 设置

    $(inherited)
    $(PROJECT_DIR)/../node_modules/rn-pocket-pingpp/ios/PingppSDK/Channels/Alipay
    $(PROJECT_DIR)/../node_modules/rn-pocket-pingpp/ios/PingppSDK/Dependencies/Network
    $(PROJECT_DIR)/../node_modules/rn-pocket-pingpp/ios/PingppSDK/Dependencies/WebView
    $(PROJECT_DIR)/../node_modules/rn-pocket-pingpp/ios/PingppSDK

注意事项:

为了用户操作完成后能够跳转回你的应用，请务必添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 TARGETS 一栏，在 Info 标签栏的 URL Types 添加 URL Schemes，如果使用微信，填入微信平台上注册的应用程序 id（为 wx 开头的字符串）。如果不使用微信，则自定义，建议起名稍复杂一些，尽量避免与其他程序冲突。允许英文字母和数字，首字母必须是英文字母，不允许特殊字符

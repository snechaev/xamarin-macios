# helpful rules to compile things for the various architectures

COMMON_I:= -I.
SIM32_I := $(COMMON_I)
SIM64_I := $(COMMON_I)
SIM_ARM64_I := $(COMMON_I)
DEV7_I  := $(COMMON_I)
DEV7s_I := $(COMMON_I)
DEV64_I := $(COMMON_I)

SIMW_I  := $(COMMON_I)
SIMW64_I  := $(COMMON_I)
DEVW_I  := $(COMMON_I)
DEVW64_32_I := $(COMMON_I)

SIM_TV_I:= $(COMMON_I)
SIM_ARM64_TV_I := $(COMMON_I)
DEV_TV_I:= $(COMMON_I)

define NativeCompilationTemplate

## ios simulator

### X64

.libs/iphonesimulator/%$(1).x86_64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,OBJC,  [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR64_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(SIM64_I) -g $(2) -c $$< -o $$@

.libs/iphonesimulator/%$(1).x86_64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,CC,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR64_CFLAGS)      $$(EXTRA_DEFINES) $(SIM64_I) -g $(2) -c $$< -o $$@

.libs/iphonesimulator/%$(1).x86_64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,ASM,   [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR64_CFLAGS)      $(SIM64_I) -g $(2) -c $$< -o $$@

.libs/iossimulator-x64$(1)/%.dylib: %.swift | .libs/iossimulator-x64$(1)
	$$(call Q_2,SWIFT, [iossimulator-x64$(1)]) $(SWIFTC)       $(IOS_SIMULATOR_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                 $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/iossimulator-x64$(1)/%.o: %.swift | .libs/iossimulator-x64$(1)
	$$(call Q_2,SWIFT, [iossimulator-x64$(1)]) $(SWIFTC)       $(IOS_SIMULATOR_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                 $$< -o $$@ -emit-object

.libs/iphonesimulator/%$(1).x86_64.dylib: | .libs/iphonesimulator
	$$(call Q_2,LD,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_IOSSIMULATOR_SDK)/lib -fapplication-extension

.libs/iphonesimulator/%$(1).x86_64.framework: | .libs/iphonesimulator
	$$(call Q_2,LD,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_IOSSIMULATOR_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/iossimulator-x64$(1)

### ARM64

.libs/iphonesimulator/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,OBJC,  [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR_ARM64_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(SIM_ARM64_I) -g $(2) -c $$< -o $$@

.libs/iphonesimulator/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,CC,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR_ARM64_CFLAGS)      $$(EXTRA_DEFINES) $(SIM_ARM64_I) -g $(2) -c $$< -o $$@

.libs/iphonesimulator/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/iphonesimulator
	$$(call Q_2,ASM,   [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR_ARM64_CFLAGS)      $(SIM64_I) -g $(2) -c $$< -o $$@

.libs/iossimulator-arm64$(1)/%.dylib: %.swift | .libs/iossimulator-arm64$(1)
	$$(call Q_2,SWIFT, [iossimulator-arm64$(1)]) $(SWIFTC)       $(IOS_SIMULATOR_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/iossimulator-arm64$(1)/%.o: %.swift | .libs/iossimulator-arm64$(1)
	$$(call Q_2,SWIFT, [iossimulator-arm64]) $(SWIFTC)       $(IOS_SIMULATOR_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                    $$< -o $$@ -emit-object

.libs/iphonesimulator/%$(1).arm64.dylib: | .libs/iphonesimulator
	$$(call Q_2,LD,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR_ARM64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_IOSSIMULATOR_SDK)/lib -fapplication-extension

.libs/iphonesimulator/%$(1).arm64.framework: | .libs/iphonesimulator
	$$(call Q_2,LD,    [iphonesimulator]) $(SIMULATOR_CC) $(SIMULATOR_ARM64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_IOSSIMULATOR_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/iossimulator-arm64$(1)

## ios device

.libs/iphoneos/%$(1).armv7.o: %.m $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,OBJC,  [iphoneos]) $(DEVICE_CC) $(DEVICE7_OBJC_CFLAGS)  $$(EXTRA_DEFINES) $(DEV7_I)  -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).armv7.o: %.c $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,CC,    [iphoneos]) $(DEVICE_CC) $(DEVICE7_CFLAGS)       $$(EXTRA_DEFINES) $(DEV7_I)  -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).armv7.dylib: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE7_CFLAGS)       $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/lib -fapplication-extension

.libs/iphoneos/%$(1).armv7.framework: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE7_CFLAGS)       $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/Frameworks -fapplication-extension

.libs/iphoneos/%$(1).armv7s.o: %.m $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,OBJC,  [iphoneos]) $(DEVICE_CC) $(DEVICE7S_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(DEV7s_I) -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).armv7s.o: %.c $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,CC,    [iphoneos]) $(DEVICE_CC) $(DEVICE7S_CFLAGS)      $$(EXTRA_DEFINES) $(DEV7s_I) -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).armv7s.dylib: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE7S_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/lib -fapplication-extension

.libs/iphoneos/%$(1).armv7s.framework: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE7S_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/Frameworks -fapplication-extension

.libs/iphoneos/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,OBJC,  [iphoneos]) $(DEVICE_CC) $(DEVICE64_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(DEV64_I) -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,CC,    [iphoneos]) $(DEVICE_CC) $(DEVICE64_CFLAGS)      $$(EXTRA_DEFINES) $(DEV64_I) -g $(2) -c $$< -o $$@ 

.libs/iphoneos/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/iphoneos
	$$(call Q_2,ASM,   [iphoneos]) $(DEVICE_CC) $(DEVICE64_CFLAGS)      $$(EXTRA_DEFINES) $(DEV64_I) -g $(2) -c $$< -o $$@

.libs/ios-arm64$(1)/%.dylib: %.swift | .libs/ios-arm64$(1)
	$$(call Q_2,SWIFT, [ios-arm64$(1)]) $(SWIFTC)    $(IOS_DEVICE_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                  $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/ios-arm64$(1)/%$(1).o: %.swift | .libs/ios-arm64$(1)
	$$(call Q_2,SWIFT, [ios-arm64$(1)]) $(SWIFTC)    $(IOS_DEVICE_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                  $$< -o $$@ -emit-object

.libs/iphoneos/%$(1).arm64.dylib: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/lib -fapplication-extension

.libs/iphoneos/%$(1).arm64.framework: | .libs/iphoneos
	$$(call Q_2,LD,    [iphoneos]) $(DEVICE_CC) $(DEVICE64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_IPHONEOS_SDK)/Frameworks -fapplication-extension  -miphoneos-version-min=$(MIN_IOS_SDK_VERSION)

RULE_DIRECTORIES += .libs/ios-arm64$(1)

## maccatalyst (ios on macOS / Catalyst)

.libs/maccatalyst/%$(1).x86_64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,OBJC,  [maccatalyst]) $(XCODE_CC) $(MACCATALYST_X86_64_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst/%$(1).x86_64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,CC,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_X86_64_CFLAGS)      $$(EXTRA_DEFINES) $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst/%$(1).x86_64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,ASM,   [maccatalyst]) $(XCODE_CC) $(MACCATALYST_X86_64_CFLAGS)                        $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst-x64$(1)/%.dylib: %.swift | .libs/maccatalyst-x64$(1)
	$$(call Q_2,SWIFT, [maccatalyst-x64$(1)]) $(SWIFTC)   $(MACCATALYST_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                              $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/maccatalyst-x64$(1)/%.o: %.swift | .libs/maccatalyst-x64$(1)
	$$(call Q_2,SWIFT, [maccatalyst-x64$(1)]) $(SWIFTC)   $(MACCATALYST_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                              $$< -o $$@ -emit-object

.libs/maccatalyst/%$(1).x86_64.dylib: | .libs/maccatalyst
	$$(call Q_2,LD,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_X86_64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_MACCATALYST_SDK)/lib -fapplication-extension

.libs/maccatalyst/%$(1).x86_64.framework: | .libs/maccatalyst
	$$(call Q_2,LD,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_X86_64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_MACCATALYST_SDK)/Frameworks -fapplication-extension

.libs/maccatalyst/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,OBJC,  [maccatalyst]) $(XCODE_CC) $(MACCATALYST_ARM64_OBJC_CFLAGS) $$(EXTRA_DEFINES) $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,CC,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_ARM64_CFLAGS)      $$(EXTRA_DEFINES) $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/maccatalyst
	$$(call Q_2,ASM,   [maccatalyst]) $(XCODE_CC) $(MACCATALYST_ARM64_CFLAGS)                        $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/maccatalyst-arm64$(1)/%.dylib: %.swift | .libs/maccatalyst-arm64$(1)
	$$(call Q_2,SWIFT, [maccatalyst-arm64$(1)]) $(SWIFTC)   $(MACCATALYST_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                           $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/maccatalyst-arm64$(1)/%.o: %.swift | .libs/maccatalyst-arm64$(1)
	$$(call Q_2,SWIFT, [maccatalyst-arm64$(1)]) $(SWIFTC)   $(MACCATALYST_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                           $$< -o $$@ -emit-object

.libs/maccatalyst/%$(1).arm64.dylib: | .libs/maccatalyst
	$$(call Q_2,LD,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_ARM64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_MACCATALYST_SDK)/lib -fapplication-extension

.libs/maccatalyst/%$(1).arm64.framework: | .libs/maccatalyst
	$$(call Q_2,LD,    [maccatalyst]) $(XCODE_CC) $(MACCATALYST_ARM64_CFLAGS)      $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_MACCATALYST_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/maccatalyst-arm64$(1)
RULE_DIRECTORIES += .libs/maccatalyst-x64$(1)

## tv simulator

### X64

.libs/tvsimulator/%$(1).x86_64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,OBJC,  [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_OBJC_CFLAGS)    $$(EXTRA_DEFINES) $(SIM_TV_I) -g $(2) -c $$< -o $$@

.libs/tvsimulator/%$(1).x86_64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,CC,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_CFLAGS)         $$(EXTRA_DEFINES) $(SIM_TV_I) -g $(2) -c $$< -o $$@

.libs/tvsimulator/%$(1).x86_64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,ASM,   [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_CFLAGS)         $$(EXTRA_DEFINES) $(SIM_TV_I) -g $(2) -c $$< -o $$@

.libs/tvossimulator-x64$(1)/%.dylib: %.swift | .libs/tvossimulator-x64$(1)
	$$(call Q_2,SWIFT, [tvossimulator-x64$(1)]) $(SWIFTC)      $(TVOS_SIMULATOR_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                        $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/tvossimulator-x64$(1)/%.o: %.swift | .libs/tvossimulator-x64$(1)
	$$(call Q_2,SWIFT, [tvossimulator-x64$(1)]) $(SWIFTC)      $(TVOS_SIMULATOR_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                        $$< -o $$@ -emit-object

.libs/tvsimulator/%$(1).x86_64.dylib: | .libs/tvsimulator
	$$(call Q_2,LD,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_CFLAGS)         $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_TVSIMULATOR_SDK)/lib -fapplication-extension

.libs/tvsimulator/%$(1).x86_64.framework: | .libs/tvsimulator
	$$(call Q_2,LD,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_CFLAGS)         $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_TVSIMULATOR_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/tvossimulator-x64$(1)

### ARM64

.libs/tvsimulator/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,OBJC,  [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_ARM64_OBJC_CFLAGS)    $$(EXTRA_DEFINES) $(SIM_ARM64_TV_I) -g $(2) -c $$< -o $$@

.libs/tvsimulator/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,CC,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_ARM64_CFLAGS)         $$(EXTRA_DEFINES) $(SIM_ARM64_TV_I) -g $(2) -c $$< -o $$@

.libs/tvsimulator/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/tvsimulator
	$$(call Q_2,ASM,   [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_ARM64_CFLAGS)         $$(EXTRA_DEFINES) $(SIM_ARM64_TV_I) -g $(2) -c $$< -o $$@

.libs/tvossimulator-arm64$(1)/%.dylib: %.swift | .libs/tvossimulator-arm64$(1)
	$$(call Q_2,SWIFT, [tvossimulator-arm64$(1)]) $(SWIFTC)      $(TVOS_SIMULATOR_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                  $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/tvossimulator-arm64$(1)/%.o: %.swift | .libs/tvossimulator-arm64$(1)
	$$(call Q_2,SWIFT, [tvossimulator-arm64$(1)]) $(SWIFTC)      $(TVOS_SIMULATOR_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                  $$< -o $$@ -emit-object

.libs/tvsimulator/%$(1).arm64.dylib: | .libs/tvsimulator
	$$(call Q_2,LD,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_ARM64_CFLAGS)         $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_TVSIMULATOR_SDK)/lib -fapplication-extension

.libs/tvsimulator/%$(1).arm64.framework: | .libs/tvsimulator
	$$(call Q_2,LD,    [tvsimulator]) $(SIMULATOR_CC) $(SIMULATORTV_ARM64_CFLAGS)         $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_TVSIMULATOR_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/tvossimulator-arm64$(1)

## tv device

.libs/tvos/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/tvos
	$$(call Q_2,OBJC,  [tvos]) $(DEVICE_CC)       $(DEVICETV_OBJC_CFLAGS)       $$(EXTRA_DEFINES) $(DEV_TV_I) -g $(2) -c $$< -o $$@ 

.libs/tvos/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/tvos
	$$(call Q_2,CC,    [tvos]) $(DEVICE_CC)    $(DEVICETV_CFLAGS)            $$(EXTRA_DEFINES) $(DEV_TV_I) -g $(2) -c $$< -o $$@ 

.libs/tvos/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/tvos
	$$(call Q_2,ASM,   [tvos]) $(DEVICE_CC)    $(DEVICETV_CFLAGS)            $$(EXTRA_DEFINES) $(DEV_TV_I) -g $(2) -c $$< -o $$@

.libs/tvos-arm64$(1)/%.dylib: %.swift | .libs/tvos-arm64$(1)
	$$(call Q_2,SWIFT, [tvos]) $(SWIFTC)      $(TVOS_DEVICE_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                         $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/tvos-arm64$(1)/%.o: %.swift | .libs/tvos-arm64$(1)
	$$(call Q_2,SWIFT, [tvos]) $(SWIFTC)      $(TVOS_DEVICE_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                         $$< -o $$@ -emit-object

.libs/tvos/%$(1).arm64.dylib: | .libs/tvos
	$$(call Q_2,LD,    [tvos]) $(DEVICE_CC)    $(DEVICETV_CFLAGS)            $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -L$(IOS_DESTDIR)$(XAMARIN_TVOS_SDK)/lib -fapplication-extension

.libs/tvos/%$(1).arm64.framework: | .libs/tvos
	$$(call Q_2,LD,    [tvos]) $(DEVICE_CC)    $(DEVICETV_CFLAGS)            $$(EXTRA_FLAGS) -dynamiclib -o $$@ $$^ -F$(IOS_DESTDIR)$(XAMARIN_TVOS_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/tvos-arm64$(1)

## macOS

.libs/mac/%$(1).x86_64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,OBJC,  [mac]) $(MAC_CC) $(MAC_OBJC_CFLAGS) $$(EXTRA_DEFINES) -arch x86_64 $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/mac/%$(1).x86_64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,CC,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_DEFINES) -arch x86_64 $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/mac/%$(1).x86_64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,ASM,   [mac]) $(MAC_CC) $(MAC_CFLAGS)                        -arch x86_64  $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/osx-x64$(1)/%.dylib: %.swift | .libs/osx-x64$(1)
	$$(call Q_2,SWIFT, [osx-x64$(1)]) $(SWIFTC) $(MACOS_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                 $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/osx-x64$(1)/%.o: %.swift | .libs/osx-x64$(1)
	$$(call Q_2,SWIFT, [osx-x64$(1)]) $(SWIFTC) $(MACOS_X64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                 $$< -o $$@ -emit-object

.libs/mac/%$(1).x86_64.dylib: | .libs/mac
	$$(call Q_2,LD,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_FLAGS) -arch x86_64 -dynamiclib -o $$@ $$^ -L$(MAC_DESTDIR)$(XAMARIN_MACOS_SDK)/lib -fapplication-extension

.libs/mac/%$(1).x86_64.framework: | .libs/mac
	$$(call Q_2,LD,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_FLAGS) -arch x86_64 -dynamiclib -o $$@ $$^ -F$(MAC_DESTDIR)$(XAMARIN_MACOS_SDK)/Frameworks -fapplication-extension

.libs/mac/%$(1).arm64.o: %.m $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,OBJC,  [mac]) $(MAC_CC) $(MAC_OBJC_CFLAGS) $$(EXTRA_DEFINES) -arch arm64 $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/mac/%$(1).arm64.o: %.c $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,CC,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_DEFINES) -arch arm64 $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/mac/%$(1).arm64.o: %.s $(EXTRA_DEPENDENCIES) | .libs/mac
	$$(call Q_2,ASM,   [mac]) $(MAC_CC) $(MAC_CFLAGS)                        -arch arm64  $(COMMON_I) -g $(2) -c $$< -o $$@

.libs/osx-arm64$(1)/%.dylib: %.swift | .libs/osx-arm64$(1)
	$$(call Q_2,SWIFT, [mac]) $(SWIFTC) $(MACOS_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                $$< -o $$@ -emit-module -L$$(dir $$@) -I$$(dir $$@) -module-name $$*

.libs/osx-arm64$(1)/%.o: %.swift | .libs/osx-arm64$(1)
	$$(call Q_2,SWIFT, [mac]) $(SWIFTC) $(MACOS_ARM64_SWIFTFLAGS) $(EXTRA_SWIFTFLAGS) $$(EXTRA_$$*_FLAGS)                                                $$< -o $$@ -emit-object

.libs/mac/%$(1).arm64.dylib: | .libs/mac
	$$(call Q_2,LD,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_FLAGS) -arch arm64 -dynamiclib -o $$@ $$^ -L$(MAC_DESTDIR)$(XAMARIN_MACOS_SDK)/lib -fapplication-extension

.libs/mac/%$(1).arm64.framework: | .libs/mac
	$$(call Q_2,LD,    [mac]) $(MAC_CC) $(MAC_CFLAGS)      $$(EXTRA_FLAGS) -arch arm64 -dynamiclib -o $$@ $$^ -F$(MAC_DESTDIR)$(XAMARIN_MACOS_SDK)/Frameworks -fapplication-extension

RULE_DIRECTORIES += .libs/osx-arm64$(1)
RULE_DIRECTORIES += .libs/osx-x64$(1)

endef

DEBUG_FLAGS=-DDEBUG -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_DEBUG
RELEASE_FLAGS=-O2 -D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_FAST

$(eval $(call NativeCompilationTemplate,,-O2))
$(eval $(call NativeCompilationTemplate,-debug,$(DEBUG_FLAGS)))
$(eval $(call NativeCompilationTemplate,-dotnet,$(RELEASE_FLAGS) -DDOTNET))
$(eval $(call NativeCompilationTemplate,-dotnet-debug,$(DEBUG_FLAGS) -DDOTNET))
$(eval $(call NativeCompilationTemplate,-dotnet-coreclr,$(RELEASE_FLAGS) -DCORECLR_RUNTIME -DDOTNET))
$(eval $(call NativeCompilationTemplate,-dotnet-coreclr-debug,$(DEBUG_FLAGS) -DCORECLR_RUNTIME -DDOTNET))
$(eval $(call NativeCompilationTemplate,-dotnet-nativeaot,$(RELEASE_FLAGS) -DCORECLR_RUNTIME -DDOTNET -DNATIVEAOT))
$(eval $(call NativeCompilationTemplate,-dotnet-nativeaot-debug,$(DEBUG_FLAGS) -DCORECLR_RUNTIME -DDOTNET -DNATIVEAOT))

.libs/iphoneos .libs/iphonesimulator .libs/tvos .libs/tvsimulator .libs/maccatalyst .libs/mac:
	$(Q) mkdir -p $@

%.csproj.inc: %.csproj $(TOP)/Make.config $(TOP)/mk/mono.mk $(TOP)/tools/common/create-makefile-fragment.sh
	$(Q) $(TOP)/tools/common/create-makefile-fragment.sh $(abspath $<) $(abspath $@)

$(RULE_DIRECTORIES):
	$(Q) mkdir -p $@

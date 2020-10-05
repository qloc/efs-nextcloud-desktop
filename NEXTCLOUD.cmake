set( APPLICATION_NAME       "EFScloud" )
set( APPLICATION_SHORTNAME  "EFScloud" )
set( APPLICATION_EXECUTABLE "efscloud" )
set( APPLICATION_DOMAIN     "efs-ag.services" )
set( APPLICATION_VENDOR     "EFS AG" )
set( APPLICATION_UPDATE_URL "https://clientupdate.efs-ag.services/client/" CACHE STRING "URL for updater" )
set( APPLICATION_HELP_URL   "" CACHE STRING "URL for the help menu" )
set( APPLICATION_ICON_NAME  "EFScloud" )
set( APPLICATION_SERVER_URL "" CACHE STRING "URL for the server to use. If entered the server can only connect to this instance" )
set( APPLICATION_REV_DOMAIN "com.efscloud.desktopclient" )

set( LINUX_PACKAGE_SHORTNAME "efscloud" )
set( LINUX_APPLICATION_ID "${APPLICATION_REV_DOMAIN}.${LINUX_PACKAGE_SHORTNAME}")

set( THEME_CLASS            "NextcloudTheme" )
set( WIN_SETUP_BITMAP_PATH  "${CMAKE_SOURCE_DIR}/admin/win/nsi" )

set( MAC_INSTALLER_BACKGROUND_FILE "${CMAKE_SOURCE_DIR}/admin/osx/installer-background.png" CACHE STRING "The MacOSX installer background image")

# set( THEME_INCLUDE          "${OEM_THEME_DIR}/mytheme.h" )
# set( APPLICATION_LICENSE    "${OEM_THEME_DIR}/license.txt )

option( WITH_CRASHREPORTER "Build crashreporter" OFF )
#set( CRASHREPORTER_SUBMIT_URL "https://crash-reports.owncloud.com/submit" CACHE STRING "URL for crash reporter" )
#set( CRASHREPORTER_ICON ":/owncloud-icon.png" )

## Updater options
option( BUILD_UPDATER "Build updater" OFF )

option( WITH_PROVIDERS "Build with providers list" ON )


## Theming options
set( APPLICATION_WIZARD_HEADER_BACKGROUND_COLOR "#00205c" CACHE STRING "Hex color of the wizard header background")
set( APPLICATION_WIZARD_HEADER_TITLE_COLOR "#ffffff" CACHE STRING "Hex color of the text in the wizard header")
option( APPLICATION_WIZARD_USE_CUSTOM_LOGO "Use the logo from ':/client/theme/colored/wizard_logo.png' else the default application icon is used" ON )


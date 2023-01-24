import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("Widgets")
        icon: "preferences-system-windows-effect-showfps"
        source: "private/Config/configWidgets.qml"
    }
    ConfigCategory {
        name: i18n("Support")
        icon: "face-angel"
        source: "private/Config/configSupport.qml"
    }
}

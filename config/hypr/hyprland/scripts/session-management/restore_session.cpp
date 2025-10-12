#include <QApplication>
#include <QMessageBox>
#include <cstdlib>
#include <string>

int main(int argc, char *argv[]) {
    // Set Wayland platform before QApplication instance
    qputenv("QT_QPA_PLATFORM", "wayland");

    QApplication app(argc, argv);

    QMessageBox msgBox;
    msgBox.setWindowTitle("Restore Session");
    msgBox.setText("Do you want to restore your previous session?");
    msgBox.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
    msgBox.setDefaultButton(QMessageBox::Yes);

    int ret = msgBox.exec();

    if (ret == QMessageBox::Yes) {
        const char* homeDir = std::getenv("HOME");
        if (homeDir) {
            std::string command = std::string(homeDir) + "/.config/hypr/hyprland/scripts/session-management/application-session-cache.sh restore";
            system(command.c_str());
        }
        return 0;
    } else {
        return 1;
    }
}

#include <QApplication>
#include <QMessageBox>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <cstdlib>
#include <string>
#include <QProcess>

int main(int argc, char *argv[]) {
    // Set Wayland platform before QApplication instance
    qputenv("QT_QPA_PLATFORM", "wayland");

    QApplication app(argc, argv);

    QString cacheFile = QString::fromUtf8(qgetenv("HOME")) + "/.cache/application-session-cache";

    QMessageBox msgBox;
    msgBox.setWindowTitle("Restore Session");
    msgBox.setText("Do you want to restore your previous session?");
    msgBox.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
    msgBox.setDefaultButton(QMessageBox::Yes);

    int ret = msgBox.exec();

    if (ret == QMessageBox::Yes) {
        QFile file(cacheFile);
        if (!file.exists()) {
            QMessageBox::critical(nullptr, "Cache file not found",
                "Cache file not found: " + cacheFile);
            return 1;
        }
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QMessageBox::critical(nullptr, "Failed to open cache file",
                "Failed to open cache file: " + cacheFile);
            return 1;
        }
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString desktopfile = in.readLine().trimmed();
            if (!desktopfile.isEmpty()) {
                QString filename = QFileInfo(desktopfile).fileName();
                // Run gtk-launch in background, suppress output
                QProcess::startDetached("gtk-launch", QStringList() << filename);
            }
        }
        file.close();
        return 0;
    } else {
        return 1;
    }
}

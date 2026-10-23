import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons as Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "raafaanavrr69.iphone"

  readonly property string ctl: Qt.resolvedUrl("bin/uxplay-ctl").toString().replace("file://", "")
  property bool running: false

  Commons.Translations { id: strings; directory: Qt.resolvedUrl("i18n") }

  function refresh() {
    if (!statusProc.running) statusProc.running = true
  }

  Process {
    id: statusProc
    command: [root.ctl, "status"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.running = String(text || "").trim() === "on"
    }
  }

  Process {
    id: toggleProc
    command: [root.ctl, "toggle"]
    onExited: root.refresh()
  }

  // The unit can also end on its own (uxplay crash, systemctl stop), so poll.
  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "\udb80\udd1c"  // nf-md-cellphone
    active: root.running
    tooltipText: root.running ? strings.t("tooltip.on") : strings.t("tooltip.off")
    onPressed: function(b) {
      if (!toggleProc.running) toggleProc.running = true
    }
  }
}

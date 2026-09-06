package app.template.patches.shared

import app.morphe.patcher.patch.AppTarget
import app.morphe.patcher.patch.Compatibility

object Constants {
    // The Waze fingerprints and resource offsets were developed against this exact
    // release. Newer Waze builds are untested and are expected to fail fingerprint
    // resolution until re-grounded.
    val WAZE_COMPATIBILITY = Compatibility(
        name = "Waze",
        packageName = "com.waze",
        appIconColor = 0x33CCFF,
        targets = listOf(
            AppTarget(version = "5.21.90.800", versionCode = 1030712)
        )
    )
}

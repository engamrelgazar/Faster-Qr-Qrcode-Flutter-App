package com.fasterqr.qrcode.fasterqr

import android.content.Intent
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService

class MyTileService : TileService() {

    override fun onTileAdded() {
        super.onTileAdded()
        val tile = qsTile
        tile.state = Tile.STATE_INACTIVE
        tile.updateTile()
    }

    override fun onStartListening() {
        super.onStartListening()
        // استمع للتغييرات هنا إذا لزم الأمر
    }

    override fun onClick() {
        super.onClick()
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivityAndCollapse(intent)
    }
}

package com.gentecdashboard.DBHelper;


import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

@Database(entities = {CRM_DataEntryGeolocationTAB.class,}, version = 1)
public abstract class BSProDB extends RoomDatabase {

    private static BSProDB INSTANCE = null;

    public abstract CRM_DataEntryGeolocationTABDao _CRM_DataEntryGeolocationTABDao();

    public static BSProDB getINSTANCE(Context context) {
        if (INSTANCE == null) {
            INSTANCE = Room.databaseBuilder(context.getApplicationContext(), BSProDB.class, "gentec-bspro")
                    .allowMainThreadQueries().build();
        }
        return INSTANCE;
    }

    public static void DestroyInstance() {
        INSTANCE = null;
    }
}
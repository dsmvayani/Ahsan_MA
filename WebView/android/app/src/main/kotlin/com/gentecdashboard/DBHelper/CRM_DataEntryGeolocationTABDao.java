package com.gentecdashboard.DBHelper;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

@Dao
public interface CRM_DataEntryGeolocationTABDao {

    @Query("SELECT * FROM CRM_DataEntryGeolocationTAB ORDER BY DataEntryDateTime asc")
    List<CRM_DataEntryGeolocationTAB> getAll();

    @Query("DELETE FROM CRM_DataEntryGeolocationTAB WHERE RecordNo = :nRecordNo")
    void deleteById(int nRecordNo);

    @Insert()
    void insertDataEntryGeolocationTAB(CRM_DataEntryGeolocationTAB crm_dataEntryGeolocationTAB);

    @Delete
    void deleteDataEntryGeolocationTAB(CRM_DataEntryGeolocationTAB crm_dataEntryGeolocationTAB);

    @Query("DELETE FROM CRM_DataEntryGeolocationTAB")
    void deleteAll();
}

package com.gentecdashboard.DBHelper;


import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.util.Date;

@Entity
public class CRM_DataEntryGeolocationTAB {
    @PrimaryKey(autoGenerate = true)
    private int RecordNo;
    private String nType;
    private String nsType;
    private String GPFormId;
    private String Event;
    private double Latitude;
    private double Longitude;
    private String DataEntryDateTime;
    private boolean isOffline;

    public CRM_DataEntryGeolocationTAB() {
    }

    public CRM_DataEntryGeolocationTAB(String NType, String nsType, String GPFormId, String event, double latitude, double longitude, String dataEntryDateTime) {
        this.nType = NType;
        this.nsType = nsType;
        this.GPFormId = GPFormId;
        Event = event;
        Latitude = latitude;
        Longitude = longitude;
        DataEntryDateTime = dataEntryDateTime;
    }

    public int getRecordNo() {
        return RecordNo;
    }

    public void setRecordNo(int recordNo) {
        RecordNo = recordNo;
    }

    public String getNType() {
        return nType;
    }

    public void setNType(String nType) {
        this.nType = nType;
    }

    public String getNsType() {
        return nsType;
    }

    public void setNsType(String nsType) {
        this.nsType = nsType;
    }

    public String getGPFormId() {
        return GPFormId;
    }

    public void setGPFormId(String GPFormId) {
        this.GPFormId = GPFormId;
    }

    public String getEvent() {
        return Event;
    }

    public void setEvent(String event) {
        Event = event;
    }

    public double getLatitude() {
        return Latitude;
    }

    public void setLatitude(double latitude) {
        Latitude = latitude;
    }

    public double getLongitude() {
        return Longitude;
    }

    public void setLongitude(double longitude) {
        Longitude = longitude;
    }

    public String getDataEntryDateTime() {
        return DataEntryDateTime;
    }

    public void setDataEntryDateTime(String dataEntryDateTime) {
        DataEntryDateTime = dataEntryDateTime;
    }

    public boolean getOffline() {
        return isOffline;
    }

    public void setOffline(boolean offline) {
        isOffline = offline;
    }
}

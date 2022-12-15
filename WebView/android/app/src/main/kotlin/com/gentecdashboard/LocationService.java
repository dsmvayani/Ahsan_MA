package com.gentecdashboard;

import android.annotation.TargetApi;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkCapabilities;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.gentecdashboard.DBHelper.BSProDB;
import com.gentecdashboard.DBHelper.CRM_DataEntryGeolocationTAB;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LocationService extends Service {
//    private static final String BASE_URL = "https://gentecbspro.com/Dummy_FlavoFood/api/";
    private static String BASE_URL = "";
    private static String Token = "";
    private static int interval = 0;

    private LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(@NonNull LocationResult locationResult) {
            super.onLocationResult(locationResult);
            if (locationResult != null && locationResult.getLastLocation() != null)
            {
                String nType = "1", nsType = "0", GPFormId = "36", Event = "Live Tracking by BS PRO";
                SimpleDateFormat format = new SimpleDateFormat("dd-MMM-yyyy  hh:mm a");
                String DataEntryDateTime = format.format(new Date());
                double latitude  = locationResult.getLastLocation().getLatitude();
                double longitude  = locationResult.getLastLocation().getLongitude();
                BSProDB db = BSProDB.getINSTANCE(getApplicationContext());
                List<CRM_DataEntryGeolocationTAB> list = db._CRM_DataEntryGeolocationTABDao().getAll();
                if(list != null && list.size() > 0){
                    for(CRM_DataEntryGeolocationTAB obj : list){
                        InsertUserLocationOnline(obj);
                    }
                    InsertUserLocationOnline(new CRM_DataEntryGeolocationTAB(nType, nsType, GPFormId, Event, latitude, longitude, DataEntryDateTime));
                }
                else{
                    CRM_DataEntryGeolocationTAB obj = new CRM_DataEntryGeolocationTAB(nType, nsType, GPFormId, Event, latitude, longitude, DataEntryDateTime);
                    InsertUserLocationOnline(obj);
                }




            }
        }
    };


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented.");
    }

    private void startLocationService(){














        String channelId = "location_notification_channel";
        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
        Intent resultIntent = new Intent();
        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0, resultIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), channelId);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setContentTitle("BS Pro Location Service");
        builder.setDefaults(NotificationCompat.DEFAULT_ALL);
        builder.setContentText("Running");
        builder.setContentIntent(pendingIntent);
        builder.setAutoCancel(false);
        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            if(notificationManager != null && notificationManager.getNotificationChannel(channelId) == null){
                NotificationChannel notificationChannel = new NotificationChannel(channelId,"BS Pro Location Service", NotificationManager.IMPORTANCE_HIGH);
                notificationChannel.setDescription("This channel is used by location service");
                notificationManager.createNotificationChannel(notificationChannel);

            }
        }
        long millisecond = 30000;
        if(interval > 0)
            millisecond = interval * 60000;
        LocationRequest locationRequest  = LocationRequest.create()
                .setInterval(millisecond)
                .setFastestInterval(millisecond)
                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

        LocationServices.getFusedLocationProviderClient(this).requestLocationUpdates(locationRequest,locationCallback, Looper.getMainLooper());
        startForeground(Constants.LOCATION_SERVICE_ID, builder.build());
    }
    private void stopLocationService(){
        LocationServices.getFusedLocationProviderClient(this).removeLocationUpdates(locationCallback);
        stopForeground(true);
        stopSelf();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if(intent != null){
            String action = intent.getAction();
            if(action != null){
                if(intent.getStringExtra("BASE_URL") != null && !intent.getStringExtra("BASE_URL").isEmpty())
                    LocationService.BASE_URL = intent.getStringExtra("BASE_URL");
                if(intent.getStringExtra("Token") != null && !intent.getStringExtra("Token").isEmpty())
                    LocationService.Token = intent.getStringExtra("Token");
                if(intent.getIntExtra("interval",0) > 0)
                    LocationService.interval = intent.getIntExtra("interval",0);
                if(action.equals(Constants.ACTION_START_LOCATION_SERVICE)){
                    startLocationService();
                }else if(action.equals(Constants.ACTION_STOP_LOCATION_SERVICE)){
                    stopLocationService();
                }
            }
        }
        return super.onStartCommand(intent, flags, startId);
    }
    private void InsertUserLocationOnline(CRM_DataEntryGeolocationTAB obj){
        int nRecordExist = obj.getRecordNo();
        if(isNetworkOnline()) {
            Map<String, Object> postparams = new HashMap<String, Object>();
            postparams.put("SPNAME", "CRM_DataEntryGeolocationSP");
            if(nRecordExist == 0){
                postparams.put("ReportQueryParameters", new Object[]{"@nType", "@nsType", "@GPFormId", "@UserId", "@Latitude", "@Longitude", "@DocumentNo", "@Event", "@DataEntryDateTime"});
                postparams.put("ReportQueryValue", new Object[]{obj.getNType(), obj.getNsType(), obj.getGPFormId(), "", obj.getLatitude(), obj.getLongitude(), "", "Schedule test  "+ obj.getEvent(), obj.getDataEntryDateTime()});
            }
            else {
                postparams.put("ReportQueryParameters", new Object[]{"@nType", "@nsType", "@GPFormId", "@UserId", "@Latitude", "@Longitude", "@DocumentNo", "@Event", "@DataEntryDateTime"});
                postparams.put("ReportQueryValue", new Object[]{obj.getNType(), obj.getNsType(), obj.getGPFormId(), "", obj.getLatitude(), obj.getLongitude(), "", "Schedule test offline "+ obj.getEvent(), obj.getDataEntryDateTime()});
            }

            postparams.put("SPNAME", "CRM_DataEntryGeolocationSP");

            UserLocationService service = RetrofitInstance.getRetrofitInstance(BASE_URL, Token).create(UserLocationService.class);
            Call<Object> call = service.InsertUserLocation("Bearer " + Token, postparams);
            call.enqueue(new Callback<Object>() {
                @Override
                public void onResponse(Call<Object> call, Response<Object> response) {
                    Log.d("Location_Response", response.message());
                    if(nRecordExist > 0)
                    {
                        BSProDB db = BSProDB.getINSTANCE(getApplicationContext());
                        db._CRM_DataEntryGeolocationTABDao().deleteById(nRecordExist);
                    }
                    if(!obj.getOffline())
                    {
                        if(response.body() != null)
                        {
                            Double  d = (Double) response.body();
                            int nInterval = d.intValue();

                            if(LocationService.interval != nInterval){
                                LocationService.interval = nInterval;
                                stopLocationService();
                                if(LocationService.interval > 0)
                                    startLocationService();
                            }

                        }


                    }

                }

                @Override
                public void onFailure(Call<Object> call, Throwable t) {
                    Log.d("Location_Response", "Something went wrong...Error message: " + t.getMessage());
                    if(nRecordExist == 0)
                        InsertUserLocationOffline(obj);
                }
            });
        }
        else{
            if(nRecordExist == 0)
                InsertUserLocationOffline(obj);
        }
    }
    private void InsertUserLocationOffline(CRM_DataEntryGeolocationTAB obj){
        BSProDB db = BSProDB.getINSTANCE(getApplicationContext());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        obj.setDataEntryDateTime(dateFormat.format(new Date()));
        obj.setOffline(true);
        db._CRM_DataEntryGeolocationTABDao().insertDataEntryGeolocationTAB(obj);
    }
    @TargetApi(Build.VERSION_CODES.M)
    public boolean isNetworkOnline() {
        boolean isOnline = false;
        try {
            ConnectivityManager manager = (ConnectivityManager) getApplicationContext().getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkCapabilities capabilities = manager.getNetworkCapabilities(manager.getActiveNetwork());  // need ACCESS_NETWORK_STATE permission
            isOnline = capabilities != null && capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isOnline;
    }

}

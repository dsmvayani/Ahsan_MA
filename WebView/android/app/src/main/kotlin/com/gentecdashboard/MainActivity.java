package com.gentecdashboard;

import android.Manifest;
import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static int REQUEST_CODE_LOCATION_PERMISSION = 1;
    private static String BASE_URL = "";
    private static String Token = "";
    private static Integer Interval = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegister.registerGeneratedPlugins( new FlutterEngine(this));

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.gentecdashboard").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                try{
                    if(call.method.equals("startFlutterBackgroundService")){
                        BASE_URL = call.argument("BASE_URL");
                        Token = call.argument("token");
                        Interval = call.argument("interval_time");
                        startFlutterBackgroundService();
                        double millis = call.argument("GPSCoordinatesStartTime");
                        long time = (long) millis;
                        if (time > 0) {

                            AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
                            Intent intentAlarm = new Intent(MainActivity.this, AlarmReceiver.class);
                            intentAlarm.putExtra("BASE_URL", BASE_URL);
                            intentAlarm.putExtra("Token", Token);
                            intentAlarm.putExtra("interval", Interval);
                            PendingIntent pendingIntent = PendingIntent.getBroadcast(MainActivity.this, 0, intentAlarm, 0);
                            alarmManager.cancel(pendingIntent);
                            alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, time, AlarmManager.INTERVAL_DAY, pendingIntent);
                        }
                        result.success("Location Service Started via Method Channel");
                    }
                    else if(call.method.equals("stopFlutterBackgroundService")){
                        stopLocationService();
                        result.success("Location Service Stoped via Method Channel");
                    }
                }
                catch (Exception ex){
                    result.error(ex.getLocalizedMessage(), ex.getMessage(), ex);
                }

            }
        });
    }
    private void startFlutterBackgroundService(){
        if(ContextCompat.checkSelfPermission(getApplicationContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_CODE_LOCATION_PERMISSION);
        }
        else
            startLocationService();
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_LOCATION_PERMISSION && grantResults.length > 0){
            if(grantResults[0] == PackageManager.PERMISSION_GRANTED){
                startLocationService();
            }
            else
                Toast.makeText(this,"Permission Denied",Toast.LENGTH_SHORT).show();
        }
    }

    private boolean isLocationServiceRunning(){
        ActivityManager activityManager = (ActivityManager)getSystemService(Context.ACTIVITY_SERVICE);
        if(activityManager != null){
            for(ActivityManager.RunningServiceInfo service : activityManager.getRunningServices(Integer.MAX_VALUE)){
                if(LocationService.class.getName().equals(service.service.getClassName())){
                    if(service.foreground){
                        return true;
                    }
                }
            }
            return false;
        }
        return false;
    }
    private void startLocationService(){
        if(!isLocationServiceRunning()){
            Intent intent = new Intent(getApplicationContext(), LocationService.class);
            intent.setAction(Constants.ACTION_START_LOCATION_SERVICE);
            //String BASE_URL = "https://gentecbspro.com/Dummy_FlavoFood/api/";
            intent.putExtra("BASE_URL", BASE_URL);
            intent.putExtra("Token", Token);
            intent.putExtra("interval", Interval);
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                startForegroundService(intent);
            }
            else
                startService(intent);
        }
    }
    private void stopLocationService(){
        if(isLocationServiceRunning()){
            Intent intent = new Intent(getApplicationContext(), LocationService.class);
            intent.setAction(Constants.ACTION_STOP_LOCATION_SERVICE);
            startService(intent);
        }
    }
}

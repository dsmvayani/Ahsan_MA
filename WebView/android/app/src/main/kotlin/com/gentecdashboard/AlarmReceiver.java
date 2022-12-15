package com.gentecdashboard;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class AlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "bspro_alarm_channel");
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setContentTitle("BS Pro Schedule Service Started");
        builder.setDefaults(NotificationCompat.DEFAULT_ALL);
        builder.setContentText("Live Tracking Schedule Service");
        builder.setAutoCancel(false);
        builder.setPriority(NotificationCompat.PRIORITY_HIGH);
        //        builder.setContentIntent(pendingIntent);

        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
        notificationManagerCompat.notify(123,builder.build());

        Intent i = new Intent(context, LocationService.class);
        i.setAction(Constants.ACTION_START_LOCATION_SERVICE);
        i.putExtra("BASE_URL", intent.getStringExtra("BASE_URL"));
        i.putExtra("Token", intent.getStringExtra("Token"));
        i.putExtra("interval", intent.getIntExtra("interval",0));
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            context.startForegroundService(i);
        }
        else
            context.startService(i);
    }
}

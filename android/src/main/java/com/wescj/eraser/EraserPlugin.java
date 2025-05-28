package com.wescj.eraser;

import android.app.NotificationManager;
import android.content.Context;
import android.service.notification.StatusBarNotification;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** EraserPlugin */
public class EraserPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "eraser");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("clearAllAppNotifications".equals(call.method)) {
      NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
      notificationManager.cancelAll();
      result.success(null);
    } else if ("clearAppNotificationsByTag".equals(call.method)) {
      String tag = call.argument("tag");
      NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
      StatusBarNotification[] notifications = notificationManager.getActiveNotifications();
      for (StatusBarNotification notification : notifications) {
        if (notification.getTag() != null && notification.getTag().equals(tag)) {
          notificationManager.cancel(tag, notification.getId());
        }
      }
      result.success(null);
    } else if ("clearAppNotificationsByTagThatContains".equals(call.method)) {
      String pattern = call.argument("pattern");
      clearNotificationsByTagPattern(pattern);
      result.success(null);
    } else {
      result.notImplemented();
    }
  }

  private void clearNotificationsByTagPattern(String pattern) {
    NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    StatusBarNotification[] notifications = notificationManager.getActiveNotifications();
    for (StatusBarNotification notification : notifications) {
      String tag = notification.getTag();
      if (tag != null && tag.contains(pattern)) {
        notificationManager.cancel(tag, notification.getId());
      }
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    context = null;
    channel.setMethodCallHandler(null);
  }
}
